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

    def request_trip(passenger_id)
      check_id(passenger_id)
      passenger = find_passenger(passenger_id)
      selected_driver = assign_driver
      if selected_driver == nil
        return nil
      end

      trip_info = { id: (@trips.length + 1), driver: selected_driver, passenger: passenger, start_time: Time.now, end_time: nil, cost: nil, rating: nil }
      trip = RideShare::Trip.new(trip_info)

      driver_id = selected_driver.id
      selected_driver.add_trip(trip)
      selected_driver.set_status(:UNAVAILABLE)
      passenger.add_trip(trip)
      @trips << trip
      return trip
    end

    def assign_driver
      available_drivers = @drivers.find_all { |driver| driver.status == :AVAILABLE }

      driver_end_times = []

      available_drivers.each do |driver|
        last_trip = driver.trips.max_by { |trip| trip.end_time }
        if last_trip != nil
          driver_end_times << { driver_id: driver.id, last_trip_time: last_trip.end_time }
        end
      end

      if driver_end_times.length == 0
        return nil
      else
        driver_end_time = driver_end_times.min_by { |entry| entry[:last_trip_time] }
        return find_driver(driver_end_time[:driver_id])
      end
    end

    private

    def check_id(id)
      if id == nil || id <= 0
        raise ArgumentError.new("ID cannot be blank or less than zero. (got #{id})")
      end
    end

  end
end
