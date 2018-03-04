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

    def find_available_drivers
      available_drivers = @drivers.find_all do |driver|
        driver.status == :AVAILABLE
      end

      if available_drivers == []
        raise ArgumentError.new("There are no drivers available.")
      else
        return available_drivers
      end
    end

    def select_driver
      # Set list of available drivers and variable to store selected_driver
      available_drivers = find_available_drivers
      selected_driver = available_drivers.first

      # If a driver is available and has no recent trips, select that person
      available_drivers.each do |driver|
        if driver.trips == []
          selected_driver = driver
          return selected_driver
        end
      end

      # If all available drivers do have trips, find each person's most recent trip
      most_recent_trips = []
      available_drivers.each do |driver|
        most_recent_trips << driver.trips.min_by do |trip|
          Time.now - trip.end_time
        end
      end

      # Isolate the driver whose most recent trip was longest ago
      oldest_trip = most_recent_trips.max_by do |trip|
        Time.now - trip.end_time
      end
      selected_driver = oldest_trip.driver
      return selected_driver
    end

    def request_trip(passenger_id)
      # load data for new trip argument
      trip_id = trips.length + 1
      passenger = find_passenger(passenger_id)
      driver = select_driver

      # throw exception if passenger id does not exist or all drivers are unavailable
      if passenger_id == nil
        raise ArgumentError.new("Invalid passenger id")
      end

      # load data to create new trip instance
      trip_data = {
        id: trip_id,
        driver: driver,
        passenger: passenger,
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil,
      }

      # call new trip
      new_trip = Trip.new(trip_data)
      trips << new_trip

      # update selected driver's trip list and their status
      driver.change_driver_status
      driver.add_trip(new_trip)

      # update passenger trip list
      passenger.add_trip(new_trip)

      return new_trip
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
