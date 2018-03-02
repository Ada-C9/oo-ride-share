require 'csv'
require 'time'
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
      driver = @drivers.find { |driver| driver.id == id }
      if driver.nil?
        raise ArgumentError.new("Driver #{id} does not exist in our records.")
      end
      return driver
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
      passenger = @passengers.find { |passenger| passenger.id == id }
      if passenger.nil?
        raise ArgumentError.new("Passenger #{id} does not exist in our records.")
      end
      return passenger
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

    def request_trip(passenger_id)
      check_id(passenger_id)
      passenger = find_passenger(passenger_id)
      driver = find_suitable_driver

      if driver.nil?
        raise StandardError.new("There are no more available drivers.")
      end

      trip_info = {
        id: @trips.length,
        passenger: passenger,
        driver: driver,
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil
      }

      trip = Trip.new(trip_info)

      driver.add_trip(trip)
      driver.new_trip_change_status
      passenger.add_trip(trip)

      @trips << trip

      return trip
    end

    def find_most_recent_trip(trips)
      most_recent_trip_end_time = trips.first.end_time
      trips.each do |trip|
        trip_end_time = trip.end_time
        if trip_end_time > most_recent_trip_end_time
          most_recent_trip_end_time = trip_end_time
        end
      end
      # returns trip end time, not trip
      return most_recent_trip_end_time
    end

    def find_suitable_driver
      new_drivers = @drivers.select do |driver|
        driver.status == :AVAILABLE && driver.trips.empty?
      end

      experienced_drivers = @drivers.select do |driver|
        driver.status == :AVAILABLE && !driver.trips.empty?
      end
      # select new, available drivers first
      # then experienced, available drivers whose most recent trip ended the earliest in time
      selected_driver = new_drivers.first
      if new_drivers.empty?

        available_drivers_not_in_progress = experienced_drivers.map do |driver|
          driver.trips.each do |trip|
            trip.end_time != nil
          end
          driver
        end

        first_driver = available_drivers_not_in_progress.first

        first_driver_trips = first_driver.trips

        most_recent_trip_end_time = find_most_recent_trip(first_driver_trips)

        selected_driver = first_driver

        available_drivers_not_in_progress.each do |driver|
          driver_trips = driver.trips

          current_driver_most_recent_trip_end_time = find_most_recent_trip(driver_trips)

          if current_driver_most_recent_trip_end_time < most_recent_trip_end_time
            most_recent_trip_end_time = current_driver_most_recent_trip_end_time
            selected_driver = driver
          end
        end
      end

      return selected_driver

    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end

    private

    def check_id(id)
      # ensure id is a digit 
      unless /^\d+$/.match(id.to_s)
        raise ArgumentError.new("ID must be a digit.")
      end
      if id == nil || id <= 0
        raise ArgumentError.new("ID cannot be blank or less than zero. (got #{id})")
      end
    end

  end # TripDispatcher

end # RideShare
