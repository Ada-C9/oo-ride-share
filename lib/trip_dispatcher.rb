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
        driver: get_oldest_driver,
        passenger: get_passenger(passenger_id),
        start_time: Time.now.to_s,
        end_time: nil,
        cost: nil,
        rating: nil
      }
      new_trip = Trip.new(new_trip_details)
      @trips << new_trip
      target_passenger = get_passenger(passenger_id)
      target_passenger.add_trip(new_trip)
      new_trip.driver.add_trip(new_trip)
      new_trip.driver.change_status

      return new_trip
    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end

    def reset_trips # to test request_trip method if there are no existing trips
      @trips = []
    end

    private

    def check_id(id)
      if id == nil || id <= 0
        raise ArgumentError.new("ID cannot be blank or less than zero. (got #{id})")
      end
    end

    def get_next_trip_id
      if @trips.empty?
        return 1
      else
        trip_ids = @trips.map { |trip| trip.id }
        sorted_ids = trip_ids.sort
        return sorted_ids.last + 1
      end
    end

    def get_oldest_driver
      available_drivers = @drivers.select { |driver| driver.status == :AVAILABLE }

      last_trips = get_last_trips(available_drivers)

      if last_trips.any? {|trip| trip.class == Driver}
        return last_trips.find {|trip| trip.class == Driver }
      elsif last_trips.empty?
          raise ArgumentError.new("Unable to create a new trip, no available drivers")
      else
        oldest_trip = last_trips.min_by {|trip| trip.end_time.to_i}
        return oldest_trip.driver
      end
    end

    def get_last_trips(driver_array)
      last_trips = []
      driver_array.each do |driver|
        if driver.trips.empty?
          last_trips << driver
        else
          ended_trips = driver.trips.select { |trip| !trip.end_time.nil? }
          end_times = ended_trips.map { |trip| trip.end_time }
          newest_end_time = end_times.max
          driver.trips.each do |trip|
            if trip.end_time == newest_end_time
              last_trips << trip
            end
          end
        end
      end
      return last_trips
    end

    def get_passenger(pass_id)
      target_passenger = @passengers.find do |passenger|
        passenger.id == pass_id
      end
      return target_passenger
    end

  end # class
end # module
