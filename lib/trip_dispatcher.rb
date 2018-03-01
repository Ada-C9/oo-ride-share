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
          start_time: raw_trip[:start_time],
          end_time: raw_trip[:end_time],
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

    def request_trip(passenger_id)
      new_trip_details = {
        id: get_next_trip_id,
        driver: get_driver,
        passenger: get_passenger(passenger_id),
        start_time: Time.now.to_s,
        end_time: nil,
        cost: nil,
        rating: nil
      }
      new_trip = Trip.new(new_trip_details)
      target_passenger = get_passenger(passenger_id)
      target_passenger.add_trip(new_trip)
      new_trip.driver.add_trip(new_trip)
      new_trip.driver.change_status

      return new_trip
    end


    private

    def check_id(id)
      if id == nil || id <= 0
        raise ArgumentError.new("ID cannot be blank or less than zero. (got #{id})")
      end
    end

    def get_next_trip_id
      trip_ids = @trips.map { |trip| trip.id }
      sorted_ids = trip_ids.sort!
      return sorted_ids.last + 1
    end

    def get_driver
      available_driver = @drivers.find do |driver|
        driver.status == :AVAILABLE
      end
      if available_driver.nil?
        raise ArgumentError.new("Unable to create a new trip, no available drivers")
      end
      return available_driver
    end

    def get_passenger(pass_id)
      target_passenger = @passengers.find do |pass|
        pass.id == pass_id
      end
      return target_passenger
    end

  end # class
end # module
