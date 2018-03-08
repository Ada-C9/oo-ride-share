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

    # Returns all drivers.
    def load_drivers
      my_file = CSV.open('support/drivers.csv', headers: true)
      all_drivers = []
      my_file.each do |line|
        input_data = {}
        vin = line[2].length == 17 ? line[2] : "0" * 17  # Set to default value
        status = line[3].to_sym
        input_data[:vin] = vin
        input_data[:id] = line[0].to_i
        input_data[:name] = line[1]
        input_data[:status] = status
        all_drivers << Driver.new(input_data)
      end
      return all_drivers
    end

    # Returns the driver with the provided id.
    def find_driver(id)
      return find_by_id(@drivers, id)
    end

    # Returns all passenger.
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

    # Returns the passenger with the provided id.
    def find_passenger(id)
      return find_by_id(@passengers, id)
    end

    # Returns all trips.
    def load_trips
      trips = []
      trip_data = CSV.open('support/trips.csv', 'r', headers: true,
        header_converters: :symbol)
      trip_data.each do |raw_trip|
        driver = find_driver(raw_trip[:driver_id].to_i)
        passenger = find_passenger_or_error(raw_trip[:passenger_id].to_i)
        parsed_trip = {
          id: raw_trip[:id].to_i,
          driver: driver,
          passenger: passenger,
          start_time: Time.parse(raw_trip[:start_time]),
          end_time: Time.parse(raw_trip[:end_time]),
          cost: raw_trip[:cost].to_f,
          rating: raw_trip[:rating].to_i
        }
        trips << make_new_trip(parsed_trip)
      end
      return trips
    end

    # Throws ArgumentError is passenger_id does not match a known passenger ID
    # or if there are no drivers available.
    # Returns a new trip.
    def request_trip(passenger_id)
      driver = find_driver_or_error
      passenger = find_passenger_or_error(passenger_id)
      trip_id = @trips.empty? ? 1 : @trips.size
      new_trip_data = {
        id: trip_id,
        driver: driver,
        passenger: passenger,
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil
      }
      @trips << make_new_trip(new_trip_data)
      return @trips.last
    end

    # Witchcraft to fix mini-test.
    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end

    private

    # Throws ArgumentError if passenger_id does not match a known passenger ID.
    # Returns the passenger with id equal to passenger_id.
    def find_passenger_or_error(passenger_id)
      passenger = find_passenger(passenger_id)
      raise ArgumentError.new("#{passenger_id} not an ID") if passenger.nil?
      return passenger
    end

    # Throws ArgumentError if provided list_to_search is an list of Passengers
    # and passenger_id does not match a known passenger ID. Provided
    # list_to_search must be a list of Drivers, Trips, or Passengers.
    # Returns the item that has the same id as provided id.
    def find_by_id(list_to_search, id)
      RideShare.return_valid_id_or_error(id)
      return list_to_search.find{ |element| element.id == id }
    end

    # Throws ArgumentError if there are no available drivers.
    # Returns an available driver.
    def find_driver_or_error
      driver = find_available_driver
      raise ArgumentError.new("No driver available") if driver.nil?
      return driver
    end

    # new_trip_data must be he information needed to create a valid trip.
    # Adds trip to trip's driver, passenger, and @trips and returns trip.
    def make_new_trip(new_trip_data)
      trip = Trip.new(new_trip_data)
      trip.driver.add_trip(trip)
      trip.passenger.add_trip(trip)
      return trip
    end

    # Returns an available driver, with priority going to the driver who has
    # never had trips and then to the driver with the least recent last trip.
    # Returns nil if cannot find an available driver.
    def find_available_driver
      longest_ago_last_trip = Time.now
      longest_ago_last_trip_driver = nil
      @drivers.each do |driver|
        next if !driver.is_available?
        return driver if driver.trips.empty? # driver has never had a trip
        last_trip_end_time = get_last_trip_end_time(driver)
        if last_trip_end_time < longest_ago_last_trip
          longest_ago_last_trip = last_trip_end_time
          longest_ago_last_trip_driver = driver
        end
      end
      return longest_ago_last_trip_driver
    end

    # Returns the most recent end trip time for provided driver. 
    def get_last_trip_end_time(driver)
      last_trip_end_time = Time.parse('1949-04-09') # needed as a placeholder
      driver.trips.each do |trip|
        last_trip_end_time = trip.end_time if last_trip_end_time < trip.end_time
      end
      return last_trip_end_time
    end

  end
end
