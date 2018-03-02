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
        driver.add_trip(trip)
        passenger.add_trip(trip)
        trips << trip
      end
      trips
    end

    # def request_trip(passenger_id)
    #   if passenger_id == nil || passenger_id <= 0
    #     raise ArgumentError.new("Invalid passenger id!")
    #   else
    #     new_rider = find_passenger(passenger_id)
    #   end
    #
    #   if @drivers.select {|driver| driver.status == :AVAILABLE}.first == nil
    #     raise ArgumentError.new("No drivers currently available!")
    #   else
    #     new_driver = @drivers.select {|driver| driver.status == :AVAILABLE}.first
    #   end
    #
    #   new_ride = RideShare::Trip.new({
    #     id: (@trips.last.id + 1),
    #     driver: new_driver,
    #     passenger: new_rider,
    #     start_time: Time.now,
    #     end_time: nil,
    #     cost: nil,
    #     rating: nil
    #     })
    #
    #   new_driver.add_trip(new_ride)
    #   new_driver.unavailable
    #   new_rider.add_trip(new_ride)
    #
    #   @trips << new_ride
    #
    #   return new_ride
    # end

    def pick_driver
      new_drivers = @drivers.select {|driver| driver.status == :AVAILABLE}

      drivers_latest_trips = []


      new_drivers.each do |driver|
        if (driver.trips.max_by {|drive| drive.end_time}) != nil
          last_trip = driver.trips.max_by {|drive| drive.end_time}
          drivers_latest_trips << {driver_id: driver.id, end_time: last_trip.end_time}
        end
      end

      if drivers_latest_trips.length == 0
        raise ArgumentError.new("No drivers available currently!")
      elsif
        new_driver_data = drivers_latest_trips.min_by {|trip_hash| trip_hash[:end_time]}

        new_driver = find_driver(new_driver_data[:driver_id])
      end
      return new_driver
    end

    def request_trip(passenger_id)
      if passenger_id == nil || passenger_id <= 0
        raise ArgumentError.new("Invalid passenger id!")
      else
        new_rider = find_passenger(passenger_id)
      end

      new_ride = RideShare::Trip.new({
        id: (@trips.last.id + 1),
        driver: pick_driver,
        passenger: new_rider,
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil
        })

      new_ride.driver.add_trip(new_ride)
      new_ride.driver.unavailable
      new_rider.add_trip(new_ride)

      @trips << new_ride
      return new_ride
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
