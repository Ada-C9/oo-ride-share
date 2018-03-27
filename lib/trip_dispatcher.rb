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

    # Automatically assign first AVAILABLE driver.
    def available?
      available_drivers =[]

      all_drivers = @drivers.find_all{ |driver| driver.status == :AVAILABLE }
        available_drivers += all_drivers

      return available_drivers
    end


    # The passenger id will be supplied. Find passenger.
    def request_trip(passenger_id)

      passenger = @passengers.find{ |passenger| passenger.id == passenger_id }

      trip_id = @trips.map { |trip| trip.id}.max + 1

      driver = available?[0]
      if driver == nil
        raise StandardError.new("There are no available drivers")
      end

      input_data = {
        id: trip_id,
        driver: driver,
        passenger: passenger,
        # Your code should use the current time for the start_time.
        start_time: Time.now,
        # Because the trip is in progress, the next 3 are nil.
        end_time: nil,
        cost: nil,
        rating: nil
      }

      # Create new trip.
      trip = Trip.new(input_data)

      # Add the new trip to the driver's collection of trips.
      driver.add_trip(trip)

      # Set the driver's status to UNAVAILABLE.


      # Add the new trip to the passenger's collection of trips.
      passenger.add_trip(trip)

      # Add the new trip to the collection of all Trips in TripDispatcher
      trips << trip

      # Return the newly created trip.
      return trip
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


    private

    def check_id(id)
      if id == nil || id <= 0
        raise ArgumentError.new("ID cannot be blank or less than zero. (got #{id})")
      end
    end
  end
end
