require 'csv'
require 'time'
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
      #header_converters gives you a hash when you use :symbol so you can use headers as keys
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
      all_available_drivers = @drivers.select{ |driver| driver.status == :AVAILABLE }

      recent_trips_of_available_drivers = []
      all_available_drivers.each do |driver|
        most_recent_trip = driver.trips.first
        driver.trips.each do |trip|
          if trip.end_time > most_recent_trip.end_time
            most_recent_trip = trip
          end
          recent_trips_of_available_drivers << most_recent_trip
        end
      end

      sorted_trips = recent_trips_of_available_drivers.flatten.sort {|trip_1, trip_2| trip_2.end_time <=> trip_1.end_time } #this puts the oldest correct drivers as the last 5

      oldest_trips = sorted_trips.uniq{ |trip| trip.driver } #using uniq to get rid of dupe trips for drivers

      if oldest_trips.empty?
        raise ArgumentError.new("There are no available drivers")
      end

      available_driver = oldest_trips.last.driver
      return available_driver
    end

    def request_trip(passenger_id)
      driver = self.find_available_driver
      passenger = self.find_passenger(passenger_id)

      trip_data = {
        id: @trips.length + 1,
        driver: driver,
        passenger: passenger,
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil
      }

      trip = Trip.new(trip_data)
      assigned_driver = trip_data[:driver]
      assigned_driver.trip_in_progress(trip)
      passenger.add_trip(trip)

      @trips << trip
      return trip
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
