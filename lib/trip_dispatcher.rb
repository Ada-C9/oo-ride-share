require 'csv'
require 'time'
require 'awesome_print'
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
          start_time: Time.parse(raw_trip[:start_time]),
          end_time: Time.parse(raw_trip[:end_time]),
          cost: raw_trip[:cost].to_f,
          rating: raw_trip[:rating].to_i
        }

        trip = Trip.new(parsed_trip)
        # Set up relations
        driver.add_trip(trip)
        passenger.add_trip(trip)

        trips << trip
      end
      return trips
    end

    def check_id(id)
      if id == nil || id <= 0
        raise ArgumentError.new("ID CANNOT BE BLANK OR LESS THAN ZERO (got #{id})")
      end
    end

    def select_available_driver
      @drivers.find do |driver|
        if driver.status == :AVAILABLE
          return driver
        end
      end
      raise ArgumentError("NO DRIVER AVAILABLE AT THIS TIME.")
    end

    def request_trip(passenger_id)
      if passenger_id.nil? || passenger_id == ''
        raise ArgumentError ("INVALID PASSENGER ID")
      end

      new_ride = {}
      # create a new ID
      new_ride[:id] = (@trips.length + 1)

      # check for the available driver
      new_ride[:driver] = select_available_driver

      # confirm passenger is valid
      passenger = find_passenger(passenger_id)
      unless passenger.nil?
        new_ride[:passenger] = passenger
      else
        raise ArgumentError("INVALID ID")
      end

      new_ride[:start_time] = Time.now
      new_ride[:end_time] = nil
      new_ride[:cost] = nil
      new_ride[:rating] = nil

      active_trip = Trip.new(new_ride)

      select_available_driver.add_trip(active_trip)
      passenger.add_trip(active_trip)

      return active_trip
    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end

    private
  end
end
