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
      found_passenger = nil
      check_id(id)

      @passengers.find do |passenger|
        if passenger.id == id
          found_passenger = passenger
        end
      end
      return found_passenger
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

      return trips
    end

    def available_drivers
      free_drivers = []
      @drivers.each do |driver|
        if driver.status == :AVAILABLE
          free_drivers << driver
        end
      end
      return free_drivers
    end

    def last_trip (driver)
      driver_trips = driver.trips
      driver_trips.sort_by! {|trip| trip.end_time}
      return driver_trips[-1]
    end

    def select_driver
      free_drivers = available_drivers
      driver_last_trip = {}
      free_drivers.each do |driver|
        if driver.trips.count == 0
          return driver
        elsif
          last_trip = last_trip(driver)
          driver_last_trip.store(driver,last_trip)
        end
      end
      driver_last_trip = driver_last_trip.sort_by{|driver, trip| trip.end_time}.to_a
      next_driver = driver_last_trip[0][0]
      return next_driver
    end

    def request_trip(passenger_id)
      start_time = Time.now
      new_trip = Hash.new
      newly_added_trip = nil
      new_trip[:id] = @trips.length
      driver = select_driver
      if driver != nil
        driver.status = :UNAVAILABLE
        new_trip[:driver] = driver
        new_trip[:passenger] = find_passenger(passenger_id)
        new_trip[:start_time] = start_time
        new_trip[:end_time] = nil
        new_trip[:cost] = nil
        new_trip[:rating] = nil
        newly_added_trip = RideShare::Trip.new(new_trip)
        @trips << newly_added_trip
      end
      return newly_added_trip
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
