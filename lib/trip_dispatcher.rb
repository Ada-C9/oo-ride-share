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
          start_time: Time.parse(raw_trip[:start_time]) || Time.now,
          end_time: Time.parse(raw_trip[:end_time]) || nil,
          cost: raw_trip[:cost].to_f || nil,
          rating: raw_trip[:rating].to_i || nil
        }

        trip = Trip.new(parsed_trip)
        driver.add_trip(trip)
        passenger.add_trip(trip)
        trips << trip
      end
      trips
    end

    def find_available_driver
      available_array = drivers.select { |driver| driver.status == :AVAILABLE }

      if available_array.length == 0
        raise ArgumentError.new "No available drivers"
      end

      available_no_trips = available_array.select { |driver| driver.trips.length == 0 }

      earliest_end_time = Time.now
      next_driver = available_array[0]

      if available_no_trips.length > 0
        next_driver = available_no_trips[0]
      else
        available_array.each do |driver|
          if driver.trips.max_by { |trip| trip.end_time }.end_time < earliest_end_time
            earliest_end_time = driver.trips.max_by { |trip| trip.end_time }.end_time
            next_driver = driver
          end
        end
        return next_driver
      end
    end


      def request_trip(passenger_id)

        if find_passenger(passenger_id) == nil || passenger_id.class != Integer
          raise ArgumentError.new "Invalid ID"
        end
        ###########Wave 2############
        # available_array = drivers.find { |driver| driver.status == :AVAILABLE }
        # if available_array == nil
        #   raise ArgumentError.new "No available drivers"
        # end
        # next_driver = available_array

        new_ride_passenger = find_passenger(passenger_id)
        next_driver = find_available_driver

        new_ride = {
          id: trips.last.id + 1,
          driver: next_driver,
          passenger: new_ride_passenger,
          start_time: Time.now,
          end_time: nil,
          cost: nil,
          rating: nil
        }

        new_trip = RideShare::Trip.new(new_ride)

        next_driver.in_progress(new_trip)
        new_ride_passenger.in_progress(new_trip)
        @trips << new_trip

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
