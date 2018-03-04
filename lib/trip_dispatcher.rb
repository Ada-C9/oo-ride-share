require 'csv'
require 'time'
require 'awesome_print'
require 'pry'

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
    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
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

    def find_available_driver
     check_status

      available_drivers = drivers.select {|driver| driver.status == :AVAILABLE }
      first_driver = compare_oldest_trip(available_drivers)

      return first_driver
    end


    def compare_oldest_trip(available_drivers)
      new_drivers = available_drivers.select {|driver| driver.trips.length == 0}

      if new_drivers.length>0
        return new_drivers.first
      end

      older = available_drivers.min_by{|driver| driver.trips.max_by{|trip| trip.end_time}.end_time}
      return older
    end

    def request_trip(passenger_id)
      passenger = find_passenger(passenger_id)

      driver = find_available_driver

      trip_id = trips.length + 1

      in_progress_data = {
        id: trip_id,
        driver: driver,
        passenger: passenger,
        start_time: Time.now,
        end_time:nil,
        cost:nil,
        rating:nil,
      }

      unfinished_trip = RideShare::Trip.new(in_progress_data)

      driver.available?(false)
      trips.push(unfinished_trip)
      driver.add_trip(unfinished_trip)
      passenger.add_trip(unfinished_trip)

      return unfinished_trip
    end

    def check_status
      if @drivers.all?{ |driver| driver.status == :UNAVAILABLE}
        raise ArgumentError.new("No available drivers")
      end
    end

    private

    def trip_time
      return trip[:start_time] - trip[:endtime]
    end

    def check_id(id)
      if id == nil || id <= 0
        raise ArgumentError.new("ID cannot be blank or less than zero.(got #{id})")
      end

    end
  end
end
