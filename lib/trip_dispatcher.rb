require 'csv'
require 'time'
require 'awesome_print'

require_relative 'driver'
require_relative 'passenger'
require_relative 'trip'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(drivers = [], passengers = [], trips = [])
      @drivers = drivers
      @passengers = passengers
      @trips = trips
      self.load_everything
    end # Initialize

    def load_everything
      @drivers += load_drivers
      @passengers += load_passengers
      @trips += load_trips
    end # load_everything

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
    end # load_drivers

    def find_driver(id)
      check_id(id)
      @drivers.find {|driver| driver.id == id }
    end # find_driver

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
    end # load_passengers

    def find_passenger(id)
      check_id(id)
      @passengers.find{ |passenger| passenger.id == id }
    end # find_passenger

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
    end # load_trips

    def next_driver
      # Array of available drivers
      all_available = @drivers.find_all do |driver|
        # Minnie (ID 100) is avail, and no current trips,
        # but assignment doesnt want us to choose her.
        driver.trips.length > 0 && driver.status == :AVAILABLE
      end

      return nil if all_available == []

      last_trips = all_available.map do |driver|
        driver.trips.min_by do |trip|
          Time.now - trip.end_time
        end
      end

      oldest_trip = last_trips.max_by do |trip|
        Time.now - trip.end_time
      end

      chosen_driver = oldest_trip.driver

      return chosen_driver
    end # next_driver

    def next_id
      ids = @trips.map {|trip| trip.id}
      return ids.max + 1
    end

    def request_trip(pass_id)

      id = self.next_id
      pass = self.find_passenger(pass_id)
      driver = self.next_driver

      if pass == nil
        raise ArgumentError.new("Sorry: Unregistred customers cannot request ride.")
      elsif driver == nil
        raise ArgumentError.new("Sorry: There are no available drivers right now.")
      end

      data = {
        id: id,
        passenger: pass,
        driver: driver,
        start_time: Time.now
      }
      new_trip = Trip.new(data)

      pass.add_trip(new_trip)
      driver.add_trip(new_trip)
      driver.status_switch

      return new_trip
    end # request_trip

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end # inspect

    private

    def check_id(id)
      if id == nil || id <= 0
        raise ArgumentError.new("ID cannot be blank or less than zero. (got #{id})")
      end
    end # check_id

  end # Class TripDispatcher
end # Module RideShare
