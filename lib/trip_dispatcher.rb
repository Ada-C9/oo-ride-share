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
          # **W1: ATTEMPT AT TIME CLASS-----
          start_time: Time.new(raw_trip[:start_time]),
          end_time: Time.new(raw_trip[:end_time]),
          # start_time: raw_trip[:start_time],
          # end_time: raw_trip[:end_time],
          # ** W1:ATTEMPT AT TIME CLASS----
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

    # **W2: METHOD TO INSTITUE REQUEST TRIP METHOD-----------
    def request_trip (passenger_id)
      if passenger_id == nil || passenger_id <= 0
        raise ArgumentError.new("ID cannot be blank or less than zero. (got #{passenger_id})")
      end
      #   # Find my passenger associated with the passenger ID
      passenger_info = @passengers.find {|passenger| passenger.id == passenger_id }
      #
      # Find a driver with an AVAILABLE STATUS (use enumerable that returns first thing that matches criteria)
      driver_info = @drivers.find {|driver| driver.status == :AVAILABLE}
      # Get start time (Time.now)
      # Get end_time (nil)
      start_time = Time.now
      end_time = nil
      # Get trip id
      trip_id = @trips.length + 1
      # assign price and rating
      trip_cost = 12.00
      trip_rate = 4
      # Make a trip (with above info)
      # RideShare::Trip.new
      fresh_trip = {
        id: trip_id,
        driver: driver_info,
        passenger: passenger_info,
        start_time: start_time,
        end_time: end_time,
        cost: trip_cost,
        rating: trip_rate
      }
      new_trip = RideShare::Trip.new(fresh_trip)

      #update Dispatch with newest trip
      @trips << new_trip

      # HELPER METHOD IN DRVIER:
      # Include this trip in Driver's overall Trips
      # Update Driver Status to UNAVAILABLE
      driver_info.update_driver(new_trip)
      #
      # UTILIZE A PREVIOUS METHOD TO ADD NEW TRIP TO PASSENGER:
      # Include this trip in Passenger's overall Trips
      #passenger_info.add_trip(new_trip)

      return new_trip
      #
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
