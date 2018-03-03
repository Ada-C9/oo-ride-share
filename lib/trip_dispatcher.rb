require 'csv'
require 'time'
require "pry"

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

    def self.split_date_time(datetime)
      #puts datetime.split("T")
      puts Time.parse(datetime)
    end

    def available_drivers
      available_drivers = []
      @drivers.each do |driver|
        if driver.status == :AVAILABLE
          available_drivers << driver
        end
      end
      return available_drivers
    end

    def driver_longest_not_driving
      drivers_lasttrip_endtime = []

      available_drivers.each do |driver|
        driver_trips_endingtime = []

        driver.trips.each do |trip|
          unless trip.end_time == nil
            driver_trips_endingtime << trip.end_time
          end
        end

        unless driver_trips_endingtime == []
          the_trip = driver_trips_endingtime.sort.last
          d = {
            id: driver.id,
            last_trip_end: the_trip
          }
          drivers_lasttrip_endtime << d
        end
      end
      if drivers_lasttrip_endtime == []
        return nil
      end 

      least_recent_last_trip = drivers_lasttrip_endtime.first[:last_trip_end]
      the_driver = drivers_lasttrip_endtime.first[:id]
      drivers_lasttrip_endtime.each do |driver|
        if driver[:last_trip_end] < least_recent_last_trip
          least_recent_last_trip = driver[:last_trip_end]
          the_driver = driver[:id]
        end
      end
      return find_driver(the_driver)
    end

    def trip_id_creator
      ids = []
      @trips.each do |trip|
        id = trip.id
        ids << id
      end
      new_id = (ids.sort.last + 1)
      return  new_id
    end




    def request_trip(passenger_id)
      trip = {
        id: trip_id_creator,
        driver: driver_longest_not_driving,
        passenger: find_passenger(passenger_id),
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil
      }

      if trip[:driver] == nil
        raise ArgumentError.new("We cannot request a new trip, there are no available drivers")
      end
      request = Trip.new(trip)
      request.driver.change_driver_status
      request.passenger.add_trip(request)
      request.driver.add_trip(request)
      @trips << request
      return request
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
