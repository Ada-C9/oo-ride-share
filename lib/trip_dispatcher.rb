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
      if id > @passengers.last.id
        raise ArgumentError.new
      else
        @passengers.find{ |passenger| passenger.id == id }
      end
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
      if any_drivers_available
        available_drivers = removes_unavailable_drivers
        new_trip = make_new_trip(passenger_id, available_drivers)
        update_trips_arrays(new_trip)
        return new_trip
      else
        return nil
      end
    end

    def any_drivers_available
      @drivers.any? {|driver| driver.status == :AVAILABLE} ? true : false
    end

    def removes_unavailable_drivers
      available_drivers = @drivers.delete_if { |driver| driver.status == :UNAVAILABLE }
      return available_drivers
    end

    def make_new_trip(passenger_id, available_drivers)
      driver = find_new_driver(available_drivers)
      # driver = available_drivers.find { |d| d.status == :AVAILABLE }
      passenger = find_passenger(passenger_id)
      start_time = Time.now

      trip_data = {
        id: passenger_id,
        driver: driver,
        passenger: passenger,
        start_time: start_time,
        end_time: nil,
        cost: nil,
        rating: nil
      }

      new_trip = Trip.new(trip_data)
      return new_trip
    end

    def find_new_driver(available_drivers)
      selected_driver = available_drivers.first
      time_passed = 0

      available_drivers.each do |driver|
        all_trips = driver.trips
        if all_trips.length != 0
          most_recent_trip = get_most_recent_trip(all_trips)
          time_difference = (Time.now - most_recent_trip.end_time)
          if time_difference > time_passed
            selected_driver = driver
            time_passed = time_difference
          end
        else
          selected_driver =  driver
          break
        end
      end

      return selected_driver
    end

    def get_most_recent_trip(all_trips)
      return sorted_trips = all_trips.sort { |x,y| x.end_time <=> y.end_time }.last
    end

    def update_trips_arrays(new_trip)
      new_trip.driver.update_driver_info(new_trip)
      new_trip.driver.add_trip(new_trip)
      new_trip.passenger.add_trip(new_trip)
      trips << new_trip
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
