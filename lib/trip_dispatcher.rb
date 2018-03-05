require 'csv'
require 'time'
require 'pry'
require 'awesome_print'

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

    def find_available
      available = @drivers.find{ |i| i.status == :AVAILABLE}
      if available == nil
        raise ArgumentError.new("Sorry, there are no available drivers.")
      else
        available = available.id
      end
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
      @highest_id = 0
      trip_data = CSV.open('support/trips.csv', 'r', headers: true, header_converters: :symbol)

      trip_data.each do |raw_trip|
        driver = find_driver(raw_trip[:driver_id].to_i)
        passenger = find_passenger(raw_trip[:passenger_id].to_i)



        parsed_trip = {
          id: raw_trip[:id].to_i,
          driver: driver,
          passenger: passenger,
          start_time: raw_trip[:start_time],
          end_time: raw_trip[:end_time],
          cost: raw_trip[:cost].to_f,
          rating: raw_trip[:rating].to_i
        }

        trip = Trip.new(parsed_trip)
        driver.add_trip(trip)
        passenger.add_trip(trip)
        trips << trip


        trips.each do |line|
          if line.id > @highest_id
            @highest_id = line.id
          end
        end
      end

      trips
    end

    def request_trip(passenger)

      driver = find_available
      highest = @highest_id + 1
      trip_info = {
        id: highest,
        driver: driver,
        passenger: passenger,
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil
      }

      another_trip = RideShare::Trip.new(trip_info)
      driver = another_trip.driver
      find_driver(driver).update_info(another_trip)

      passenger = another_trip.passenger
      find_passenger(passenger).update_info(another_trip)

      return another_trip
    end


    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end

    # any method below private cannot be called to operate by other methods
    # this is because it's best practice to make things as private as possible by default
    private

    def check_id(id)
      if id == nil || id <= 0
        raise ArgumentError.new("ID cannot be blank or less than zero. (got #{id})")
      end
    end


  end
end
