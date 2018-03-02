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

    # This method checks the driver id and makes sure we have a valid id
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

      # header_converters: :symbol means to take the first line of headers
      # to make into keys
      # taking the raw data from the CSV
      trip_data.each do |raw_trip|
        driver = find_driver(raw_trip[:driver_id].to_i)
        passenger = find_passenger(raw_trip[:passenger_id].to_i)

        if driver.nil? || passenger.nil?
          raise "Could not find driver or passenger trip ID #{raw_trip[:id]}"
        end

        # setting up parsed_trip to take in the raw_trip data
        # prepping it for the Trip class
        parsed_trip = {
          id: raw_trip[:id].to_i,
          driver: driver,
          passenger: passenger,
          start_time: Time.parse(raw_trip[:start_time]),
          end_time: Time.parse(raw_trip[:end_time]),
          cost: raw_trip[:cost].to_f,
          rating: raw_trip[:rating].to_i
        }

        # this setting up the instance of trip
        trip = Trip.new(parsed_trip)

        # Set up relations
        driver.add_trip(trip)
        passenger.add_trip(trip)
        trips << trip
      end

      return trips
    end

    # this method goes through and finds the first driver with status that is :AVAILABLE
    def available_driver
      @drivers.each do |driver|
        if driver.status == :AVAILABLE
          return driver
        end
      end
      raise ArgumentError.new("There are no drivers available at this time")
    end

    def request_trip(passenger_id)

      passenger = find_passenger(passenger_id)

      if passenger.nil?
        raise "Could not find passenger trip ID #{passenger_id}"
      end

      trip_id = trips.length + 1

      trip = {
        id: trip_id,
        driver: available_driver,
        passenger: passenger,
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil
      }

      new_trip = Trip.new(trip)

      available_driver.add_trip(new_trip)
      passenger.add_trip(new_trip)
      trips << new_trip

      return new_trip
    end # end of request_trip(passenger_id)

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end

    private

    def check_id(id)
      if id == nil || id <= 0
        raise ArgumentError.new("ID cannot be blank or less than zero. (got #{id})")
      end
    end

  end # end of TripDispatcher class
end # end of RideShare module

# testing_code = RideShare::TripDispatcher.new
# puts testing_code.request_trip(21)
