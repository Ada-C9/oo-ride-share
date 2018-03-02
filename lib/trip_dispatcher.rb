require 'csv'
require 'time'
require 'awesome_print'

require_relative 'driver'
require_relative 'passenger'
require_relative 'trip'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(drivers = [], passengers = [], trips = [])
      @drivers = drivers
      @passengers = passengers
      @trips = trips
      self.load_everything
    end

    def load_everything
      @drivers += load_drivers
      @passengers += load_passengers
      @trips += load_trips
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

      return trips
    end

    def next_driver
      # Array of available drivers
      all_available = @drivers.find_all do |driver|
        # Minnie (ID 100) is avail, and no current trips,
        # but assignment doesnt want us to choose her.
        driver.trips.length > 0 && driver.status == :AVAILABLE
      end

      # None Available
      return nil if all_available == []

      # Array of last trips
      last_trips = all_available.map do |driver|
        driver.trips.min_by do |trip|
          Time.now - trip.end_time
        end
      end

      # The oldest trip
      oldest_trip = last_trips.max_by do |trip|
        Time.now - trip.end_time
      end

      # The driver that gets the trip
      chosen_driver = oldest_trip.driver
      return chosen_driver

    end

    def request_trip(pass_id)
      pass = self.find_passenger(pass_id)
      driver = self.next_driver
      puts "Driver selected: "
      puts driver
      puts

      if pass == nil
        raise ArgumentError.new("Sorry: Unregistred customers cannot request ride.")
      elsif driver == nil
        raise ArgumentError.new("Sorry: There are no available drivers right now.")
      end

      data = {
        id: @trips.length + 1,
        passenger: pass,
        driver: driver,
        start_time: Time.now
      }
      new_trip = Trip.new(data)
      pass.add_trip(new_trip)
      driver.add_trip(new_trip)
      driver.status_switch

      return new_trip
    end # request_trip

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

# disp = RideShare::TripDispatcher.new
# antwan = disp.find_driver(14)
#
# puts "Current status, before method: #{antwan.status}"
# puts "Antwan's trips before method: #{antwan.trips}"
#
# result =  disp.request_trip(5)
# puts result.driver.name
# puts result.driver.id
# puts "Current status, AFTER method: #{antwan.status}"
# puts "Antwan's trips AFTER method: #{antwan.trips}"
#
# avail = disp.drivers.find_all do |driver|
#   driver.status == :AVAILABLE
# end
# ap avail
#
# puts
#
# puts
# puts
# puts "My find driver method gets me: "
# puts "#{disp.next_driver.name}"
# puts
# puts
# new_one = disp.request_trip(26)
#
# puts new_one.driver.name
# puts new_one.driver.id
