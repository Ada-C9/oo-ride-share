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

    def select_driver
      # For this initial version, choose the first driver whose status is :AVAILABLE
      @drivers.each {|driver| return select_driver = driver if driver.status == :AVAILABLE }
      # @drivers.find{ |driver| driver.status == :AVAILABLE }
    end


    def request_trip(passenger_id)
      passenger = find_passenger(passenger_id)

      select_driver

      in_progress_trip = {
        id: (@trips.size + 1),
        driver: select_driver,
        passenger: passenger,
        start_time: Time.now, #Your code should use the current time for the start time
        end_time: nil,
        cost: nil,
        rating: nil,
      }

      # Create a new instance of Trip:
      trip_in_progress = Trip.new(in_progress_trip)

      # Add the new trip to the collection of trips for that Driver:
      select_driver.add_trip(trip_in_progress)
      # Set the driver's status to :UNAVAILABLE:
      select_driver.change_status

      # Add the new trip to the collection of trips for the Passenger:
      passenger.add_trip(trip_in_progress)

      # Add the new trip to the collection of all Trips in TripDispatcher:
      trips << trip_in_progress

      # Return the newly created trip:
      return trip_in_progress
    end

    private

    def check_id(id)
      if id == nil || id <= 0
        raise ArgumentError.new("ID cannot be blank or less than zero. (got #{id})")
      end
    end
  end
end

trip_disp = RideShare::TripDispatcher.new()
# puts trip_disp.drivers
# puts trip_disp.passengers[0].id
puts "trip_disp.trips.length = #{trip_disp.trips.length}"

new_trip = trip_disp.request_trip(1)

puts "new_trip = #{new_trip}"
puts "new_trip.id = #{new_trip.id}"

puts "new trip driver = #{new_trip.driver}"
# puts trip_disp.request_trip(1).start_time
puts "trip_disp.trips.length = #{trip_disp.trips.length}"
