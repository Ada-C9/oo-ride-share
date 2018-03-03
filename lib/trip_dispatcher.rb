require 'csv'
require 'time'
require_relative 'driver'
require_relative 'passenger'
require_relative 'trip'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize
      @drivers = load_drivers
      @passengers = load_passengers
      @trips = load_trips
    end

    def load_drivers
      my_file = CSV.open('support/drivers.csv', headers: true)

      all_drivers = []
      my_file.each do |line|
        input_data = {}
        # Set to a default value
        vin = line[2].length == 17 ? line[2] : "0" * 17

        # Status logic
        status = line[3]
        status = status.to_sym

        input_data[:vin] = vin
        input_data[:id] = line[0].to_i
        input_data[:name] = line[1]
        input_data[:status] = status
        all_drivers << Driver.new(input_data)
      end

      return all_drivers
    end

    def find_driver(id)
      check_id(id)
      @drivers.find{ |driver| driver.id == id }
    end

    def load_passengers
      passengers = []

      CSV.read('support/passengers.csv', headers: true).each do |line|
        input_data = {}
        input_data[:id] = line[0].to_i
        input_data[:name] = line[1]
        input_data[:phone] = line[2]

        passengers << Passenger.new(input_data)
      end

      return passengers
    end

    def find_passenger(id)
      check_id(id)
      @passengers.find{ |passenger| passenger.id == id }
    end

    def load_trips
      trips = []
      trip_data = CSV.open('support/trips.csv', 'r', headers: true, header_converters: :symbol)

      trip_data.each do |raw_trip|
        driver = find_driver(raw_trip[:driver_id].to_i)

        passenger = find_passenger(raw_trip[:passenger_id].to_i)

        parsed_trip = {
          id: raw_trip[:id].to_i,
          driver: driver,
          passenger: passenger,
          start_time: Time.parse(raw_trip[:start_time]),
          end_time: Time.parse(raw_trip[:end_time]),
          cost: raw_trip[:cost].to_f,
          rating: raw_trip[:rating].to_i
        }
        trip = Trip.new(parsed_trip)
        driver.add_trip(trip)
        passenger.add_trip(trip)
        trips << trip
      end

      trips
    end

    def request_trip(passenger_ID)
      #first driver who is available
      a_driver = drivers.detect{|driver|driver.status == :AVAILABLE}
      if a_driver == nil
        new_trip = nil
      else
        #should I add a finder to passenger or can i
        #do the finding here?
        #a_passenger = passengers.detect{|passenger|passenger.id == passenger_ID}
        a_passenger = find_passenger(passenger_ID)
        start_time = Time.now
        new_trip = RideShare::Trip.new({id:passenger_ID,driver:a_driver,passenger:a_passenger,start_time:start_time,end_time: :PENDING, rating: :PENDING,cost: 0})
        a_driver.add_trip(new_trip)
        a_driver.status = :UNAVAILABLE
        a_passenger.trips << new_trip
        trips << new_trip
      end

      return new_trip
    end

    def assign_by_driver_status(passenger_ID)
      available_drivers = drivers.find_all{|driver|driver.status == :AVAILABLE}
      if available_drivers == nil || available_drivers.length == 0
        return nil
      end

      driver_iterations = available_drivers.length
      available_driver_with_longest_wait_time = available_drivers[0]
      index = 0

    
        driver_iterations.times do
          if available_drivers[index].trips.empty? || available_drivers.length == 1
            available_driver_with_longest_wait_time = available_drivers[index]
            break
          elsif available_drivers[index].trips[-1].end_time < available_driver_with_longest_wait_time.trips[-1].end_time
            available_driver_with_longest_wait_time = available_drivers[index]
          end
            index+=1
          end

          a_passenger = find_passenger(passenger_ID)

          start_time = Time.now
          new_trip = RideShare::Trip.new({id:passenger_ID,driver:available_driver_with_longest_wait_time,passenger:a_passenger,start_time:start_time,end_time: :PENDING, rating: :PENDING,cost: 0})
          available_driver_with_longest_wait_time.add_trip(new_trip)
          available_driver_with_longest_wait_time.status = :UNAVAILABLE
          a_passenger.trips << new_trip
          trips << new_trip

      return new_trip
        #driver has been set an changed to unavailable
    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end

    private

    def check_id(id)
      if id == nil || id <= 0
        raise ArgumentError.new("ID cannot be blank or less than zero. (got #{id})")
      end
    end
  end
end
