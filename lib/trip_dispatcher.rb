require 'csv'
require 'time'
require 'awesome_print'

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

        # if driver.nil? || passanger.nil?
        #   raise "Could not find driver or passanger "
        # end

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

    def select_driver_available
      # Find the first available driver:
      @drivers.each {|driver| return select_driver_available = driver if driver.status == :AVAILABLE }
    end

    def request_trip(passenger_id)
      # Initiate a new trip:

      passenger = find_passenger(passenger_id)

      raise ArgumentError.new("Passanger with id #{passenger_id} does not exist.") if passenger == nil

      select_driver_available

      in_progress_trip = {
        id: (@trips.size + 1),
        driver: select_driver_available,
        passenger: passenger,
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil,
      }

      # Create a new instance of Trip:
      trip_in_progress = Trip.new(in_progress_trip)

      # Add the new trip to the collection of trips for that Driver:
      begin
        select_driver_available.add_trip(trip_in_progress)
      rescue SystemCallError => exception
        puts "There is no available drivers #{exception.message}"
      end

      # Set the driver's status to :UNAVAILABLE:
      select_driver_available.change_status

      # Add the new trip to the collection of trips for the Passenger:
      passenger.add_trip(trip_in_progress)

      # Add the new trip to the collection of all Trips in TripDispatcher:
      trips << trip_in_progress

      # Return the newly created trip:
      return trip_in_progress
    end



    # ___________Wave 3:

    def select_the_right_driver

      # Find a driver with no trips:
      select_driver_with_no_trips
      if select_driver_with_no_trips != nil
        right_driver = select_driver_with_no_trips
        return right_driver
      end
      # return select_driver_with_no_trips

      # Create a hash with latest trips of all drivers: array[driver, lastest_trip]
      lastest_trips_of_all_drivers = find_lastest_trips_of_all_drivers

      # Select only the availables ones: array[driver, lastest_trip]
      only_available = only_available(lastest_trips_of_all_drivers)

      # Select the driver with the earliest end of trip in the hash:
      earliest_end_time = Time.now
      right_driver = nil

      ap "only_available = #{only_available.length}"

      only_available.each do |sub_array|
        if sub_array[1] == nil
          return right_driver = sub_array[0]
        end
        # elsif
        if sub_array[1].end_time != nil
          ap "not equal nil"
          # else
          # right_driver =  sub_array.min_by {|end_time| sub_array[1].end_time.to_i}

          if
            sub_array[1].end_time.to_i < earliest_end_time.to_i
            earliest_end_time = sub_array[1].end_time
            ap "earliest_end_time = #{earliest_end_time}"
            ap "driver status = #{sub_array[0].status}"
            right_driver = sub_array[0]
          end
        end
      end
      # puts "right_driver = #{right_driver}"
      return right_driver
    end

    def find_lastest_trips_of_all_drivers
      # Returns a hash with {driver: latest_trip}
      lastest_trips_of_all_drivers = []

      @drivers.each do |driver|
        last = driver.trips.max_by { |trips| trips.end_time.to_i }
        lastest_trips_of_all_drivers << [driver, last]
      end

      # @drivers.each do |driver|
      #   # lastest_trips_of_all_drivers[:"#{driver}"] = driver.trips.last
      #
      #    lastest_trips_of_all_drivers << [driver, last]
      # lastest_trips_of_all_drivers << [driver, driver.trips.last]
      #  Hash[lastest_trips_of_all_drivers]
      # end
      return lastest_trips_of_all_drivers
    end

    def select_driver_with_no_trips
      select_driver_with_no_trips = nil

      @drivers.each {|driver| return select_driver_with_no_trips = driver if driver.trips == 0 }

      return select_driver_with_no_trips #if select_driver_with_no_trips != nil
    end

    def only_available(lastest_trips_of_all_drivers)
      available_drivers = []
      lastest_trips_of_all_drivers.each do |index|
        if index[0].status == :AVAILABLE
          available_drivers << index
        end
      end
      return available_drivers
    end

    def better_request_new_trip(passenger_id)
      # Initiate a new trip:

      passenger = find_passenger(passenger_id)
      raise ArgumentError.new("Passanger with id #{passenger_id} does not exist.") if passenger == nil


      right_driver = select_the_right_driver
      if right_driver.nil?
        raise StandardError
        puts "There is no available drivers"
      end


      # Create a new instance of Trip:
      in_progress_trip = {
        id: (@trips.size + 1),
        driver: right_driver,
        passenger: passenger,
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil,
      }
      trip_in_progress = Trip.new(in_progress_trip)
      # ap "FILE new_trip:"
      ap trip_in_progress
      # Add the new trip to the collection of trips for that Driver:

      # ap "FILE first row"
      # ap right_driver.trips

      right_driver.add_trip(trip_in_progress)

      # ap "FILE second row"
      # ap right_driver.trips

      # Set the driver's status to :UNAVAILABLE:
      right_driver.change_status

      # Add the new trip to the collection of trips for the Passenger:
      passenger.add_trip(trip_in_progress)

      # Add the new trip to the collection of all Trips in TripDispatcher:
      trips << trip_in_progress

      # Return the newly created trip:
      return trip_in_progress
    end

    def inspect
      # Fix testing bug:
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end

    private

    def check_id(id)
      # Check if it is a valid ID
      if id == nil || id <= 0
        raise ArgumentError.new("ID cannot be blank or less than zero. (got #{id})")
      end
    end
  end
end


# The Driver must have a status of AVAILABLE
# The Driver must not have any in-progress trips (end time of nil)
# From the Drivers that remain, select the one whose most recent trip ended the longest time ago

# trip_dispatcher = RideShare::TripDispatcher.new()
# Request new trip:
# testing = trip_dispatcher.select_the_right_driver
# puts testing

# ap trip_dispatcher.find_lastest_trips_of_all_drivers
# ap trip_dispatcher.select_the_right_driver
