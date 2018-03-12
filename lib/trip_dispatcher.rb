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

    def find_passenger(id) # will return nil if a passenger was not found
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

      return trips
    end

    def request_trip(passenger_id)

      if find_passenger(passenger_id).nil?
        raise ArgumentError.new("A trip can only be requested for an existing customer.")
      end

      new_trip_data = {
        id: new_trip_id,
        passenger: find_passenger(passenger_id),
        driver: select_driver,
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil
      }

      new_trip = Trip.new(new_trip_data)

      @trips << new_trip
      new_trip.driver.add_trip(new_trip)
      new_trip.passenger.add_trip(new_trip)

      new_trip.driver.change_status

      return new_trip
    end

    def new_trip_id
      @trips.map { |trip| trip.id }.max + 1
    end

    def available_drivers
      available_drivers = @drivers.select do |driver|
        driver.status == :AVAILABLE && driver.trips.length > 0
      end

      if available_drivers.nil?
        raise StandardError.new("There are no availabe drivers at this time. A trip cannot be requested.")
      end

      return available_drivers
    end

    def most_recent_trip_by_driver
      most_recent_trip_by_driver = available_drivers.map do |driver|
        driver.trips.max_by do |trip|
          trip.end_time
        end
      end

      return most_recent_trip_by_driver
    end

    def select_driver
      most_distant_trip = most_recent_trip_by_driver.min_by do |trip|
        trip.end_time
      end

      return most_distant_trip.driver
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
