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

        # set up relations
        driver.add_trip(trip)
        passenger.add_trip(trip)
        trips << trip
      end

      return trips
    end
    def request_trip(passenger_id)
      #refactor variable driver for wave 3 requirements
      driver = driver_selection

      raise ArgumentError.new("Sorry, currently no available drivers") if driver == nil

      passenger = self.find_passenger(passenger_id)
      new_id = 1 + self.gets_new_trip_id


      trip_data = {id: new_id,
        driver: driver,
        passenger: passenger,
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil
      }

      raise ArgumentError.new("Ride cannot be processed, passenger not registered") if trip_data[:passenger].nil?

      trip = Trip.new(trip_data)

      passenger.add_trip(trip)
      driver.add_trip(trip)
      driver.unavailable

      @trips << trip

      return trip

    end

    # helper method to calculate the next new id
    def gets_new_trip_id
      next_id = @trips.max_by {|trip| trip.id}
      return next_id.id
    end

    # helper method to next driver with status available and oldest recent trip.
    def driver_selection
      drivers_available = drivers.find_all do |driver|
        driver.status == :AVAILABLE
      end

      return nil if drivers_available.length == 0

      # Collect the last trip of each of the drivers available
      oldest_trips = []
      drivers_available.each do |driver|
        oldest_trip = driver.trips.max_by do |trip|
          trip.end_time
        end

        if oldest_trip != nil
          oldest_trips.push({driver_id: driver.id, end_time_of_oldest_trip: oldest_trip.end_time})
        end
      end

      # The minimum value of oldest_trips array will be the oldest trip.
      driver_selected_info = oldest_trips.min_by do |data|
        data[:end_time_of_oldest_trip]
      end

      return find_driver(driver_selected_info[:driver_id])

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
