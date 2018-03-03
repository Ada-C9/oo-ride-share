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

    def request_trip(passenger_id)
      # input is passenger_id
      # Your code should automatically assign a driver to the trip
      # For this initial version, choose the first driver whose status is :AVAILABLE
      # The trip hasn't finished yet!
      available_driver = drivers.find {|driver| driver.status == :AVAILABLE }
      selected_passenger = passengers.find {|passenger| passenger.id == passenger_id}
      max_trip_id = trips.map {|trip| trip.id}.max

      input_hash = {
        :id => max_trip_id + 1,
        :driver => available_driver,
        :passenger => selected_passenger,
        # Your code should use the current time for the start time
        :start_time => Time.now,
        # The end date, cost and rating will all be nil
        :end_time => nil,
        :cost => nil,
        :rating => nil
      }


      # output must be new instance of a trip
      new_trip = Trip.new(input_hash)

      available_driver.add_trip(new_trip)
      # Modify the passenger for the trip using a new helper method in Passenger:
      # Add the new trip to the collection of trips for the Passenger
      selected_passenger.add_trip(new_trip)
      # Add the new trip to the collection of all Trips in TripDispatcher
      @trips << new_trip
      # Return the newly created trip
      return new_trip
    end # ends "request_trip" method

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
      return all_drivers # <- an array of new driver instances
    end # ends "load_drivers" method

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
        #there is no trip list in here to start with
        passengers << Passenger.new(input_data)
      end
      return passengers
    end # ends "load_passengers" method

    def find_passenger(id) # <-- for the beginning of Wave 2
      check_id(id)
      @passengers.find{ |passenger| passenger.id == id }
    end

    def load_trips
      trips = []
      trip_data = CSV.open('support/trips.csv', 'r', headers: true, header_converters: :symbol)

      # raw data from trips.CSV
      trip_data.each do |raw_trip|
        #
        driver = find_driver(raw_trip[:driver_id].to_i)
        passenger = find_passenger(raw_trip[:passenger_id].to_i)

        # Charles suggests we add this (from group review 28 Feb 2018)
        if driver.nil? || passenger.nil?
          raise "Could not find driver or passenger for trip ID #{raw_trip[:id]}"
        end

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
    end # ends "load_trips" method

    # Dee/Charles suggested to add this via Slack post
    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end # ends "inspect" method

    private

    def check_id(id)
      if id == nil || id <= 0
        raise ArgumentError.new("ID cannot be blank or less than zero. (got #{id})")
      end
    end # ends "check_id" method

  end # ends class TripDispatcher
end # ends module RideShare
