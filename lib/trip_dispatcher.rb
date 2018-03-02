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
      passenger = @passengers.find { |passenger| passenger.id == id }
      # binding.pry
      if passenger.nil?
        raise ArgumentError.new("Passenger #{id} does not exist in our records.")
      end
      return passenger
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
      # binding.pry

      trips
    end

    def request_trip(passenger_id)
      # check passenger_id here
      check_id(passenger_id)

      passenger = find_passenger(passenger_id)

      # if passenger.nil?
      #   raise ArgumentError.new("Passenger #{passenger_id} does not exist in our records.")
      # end

      # binding.pry

      # driver = @drivers.find do |driver|
      #   driver.status == :AVAILABLE
      # end
      driver = find_suitable_driver


      if driver.nil?
        raise StandardError.new("There are no more available drivers.")
      end

      trip_info = {
        id: @trips.length,
        passenger: passenger,
        driver: driver,
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil
      }

      trip = Trip.new(trip_info)

      driver.add_trip(trip)
      driver.new_trip_change_status
      passenger.add_trip(trip)

      @trips << trip

      return trip
    end

    def find_most_recent_trip(trips)
      most_recent_trip_end_time = trips.first.end_time
      trips.each do |trip|
        trip_end_time = trip.end_time
        if trip_end_time > most_recent_trip_end_time
          most_recent_trip_end_time = trip_end_time
        end
      end
      return most_recent_trip_end_time
    end

    def find_suitable_driver
      # step 1 look through drivers
      # step 2 select drivers with available status
      available_drivers = @drivers.select do |driver|
        # exclude available drivers who have completed no trips at all
        driver.status == :AVAILABLE && !driver.trips.empty?
      end

      # step 3 look at each driver's trips
      # step 4 create pool of drivers if end_time.nil? is false
      # exclude driver if any of their trips has end_time == nil
      available_drivers_not_in_progress = available_drivers.map do |driver|
        driver.trips.each do |trip|
          trip.end_time != nil
        end
        driver
      end

      # binding.pry

      # step 6 select the first driver
      first_driver = available_drivers_not_in_progress.first

      # step 6b loop through trips of first driver
      first_driver_trips = first_driver.trips
      # # step 6c find most recent trip
      # most_recent_trip_end_time = Time.new
      # first_driver_trips.each do |trip|
      #   trip_end_time = trip.end_time
      #   if trip_end_time > most_recent_trip_end_time
      #     most_recent_trip_end_time = trip_end_time
      # end

      most_recent_trip_end_time = find_most_recent_trip(first_driver_trips)

      selected_driver = first_driver


      # step 5 loop through final pool of drivers
      # get current driver
      available_drivers_not_in_progress.each do |driver|
        # look at current driver's trips
        driver_trips = driver.trips

        # find most recent trip
        current_driver_most_recent_trip_end_time = find_most_recent_trip(driver_trips)

        # binding.pry

        # compare current driver's most recent trip to last driver's most recent trip
        # if former is earlier in time, reset most recent trip to current driver's most recent trip
        # reassign driver to current driver
        if current_driver_most_recent_trip_end_time < most_recent_trip_end_time
          most_recent_trip_end_time = current_driver_most_recent_trip_end_time
          selected_driver = driver
        end
        # if latter is earlier in time, do nothing
        # end comparison
        # end loop
      end

      return selected_driver

      # return driver
    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end

    private

    def check_id(id)
      unless /^\d+$/.match(id.to_s)
        raise ArgumentError.new("ID must be a digit.")
      end
      if id == nil || id <= 0
        raise ArgumentError.new("ID cannot be blank or less than zero. (got #{id})")
      end
    end

  end # TripDispatcher

end # RideShare


# dispatcher = RideShare::TripDispatcher.new
# puts dispatcher.request_trip(1)

# dispatcher = RideShare::TripDispatcher.new
# result = dispatcher.request_trip(1)
# puts result
