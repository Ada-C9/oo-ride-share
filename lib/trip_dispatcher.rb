require 'csv'
require 'time'
require 'pry'
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

    def assign_driver
      ### WAVE 2 ### passes test
      # drivers_available = @drivers.reject { |driver| driver.status == :UNAVAILABLE }
      #
      # if drivers_available.length == 0
      #   raise ArgumentError.new("There are no drivers available.")
      # else
      #   return drivers_available.first
      # end

      ### WAVE 3 ATTEMPT ###

      drivers_pool = drivers.reject { |driver| (driver.status == :UNAVAILABLE) || (driver.trips.length == 0)}

      # last_trips = drivers_pool.map { |trips| trips.trips.last }

      # last_time = last_trips.min_by { |trip| trip.end_time}
      most_recent = []
      drivers_pool.each do |driver|
        most_recent << driver.trips.max_by { |trip| trip.end_time }
      end

      # most_recent.each do |trip|
      #   puts trip.driver.name
      #   puts trip.end_time
      # end

      oldest = most_recent.min_by { |trip| trip.end_time }

      puts oldest
      puts oldest.id
      puts oldest.driver.name
      puts oldest.end_time
      # # puts last_rides.min_by { |trip| trip }


      # puts last_time.end_time
      # puts last_time.driver.id

      # chosen = drivers_pool.min_by { |driver| driver.trips.last.id}

      # time = drivers_pool.map { |x| x.trips.last.end_time}
      #
      # chosen = time.min


    end

    def request_trip(passenger_id)

      check_id(passenger_id)
      passenger = find_passenger(passenger_id)

      if passenger == nil
        raise ArgumentError.new("Passenger ID #{passenger_id} not valid.")
      else
        driver = assign_driver

        trip_data = {
          id: @trips.length + 1,
          driver: driver,
          passenger: passenger,
          start_time: Time.now,
          end_time: nil,
          cost: nil,
          rating: nil,
        }

        new_trip = Trip.new(trip_data)
        driver.change_to_unavailable
        driver.add_trip(new_trip)
        passenger.add_trip(new_trip)
        trips << new_trip
        return new_trip
      end
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
#

# passenger = RideShare::Passenger.new({id: -23, name: "Smithy", phone: "353-533-5334"})
# puts passenger
dispatcher = RideShare::TripDispatcher.new
puts dispatcher.assign_driver
### TESTING FOR REQUESTING TRIP ####
# dispatcher = RideShare::TripDispatcher.new
# # puts dispatcher.assign_driver.length
# first_driver = dispatcher.find_driver(2)
# # puts first_driver.trips.length
# puts "Drivers count before #{first_driver.trips.length}"
# new_trip = dispatcher.request_trip(3)
# driver = new_trip.driver
# puts driver.id
# puts "Drivers count after: #{driver.trips.length}"

# actual_driver = dispatcher.find_driver(2)
# puts "original passenger trips #{passenger.trips.length}"
# puts "original driver trips : #{actual_driver.trips.length}"
#
# puts dispatcher.trips.length
# new_trip = dispatcher.request_trip(3)
# puts new_trip
# puts new_trip.class
# puts new_trip.id
# driver = new_trip.driver
# puts "Driver ID : #{driver.id}"
# puts "Driver Status: #{driver.status}"
# passenger = new_trip.passenger
# passenger = dispatcher.find_passenger(2)
#
# puts "Final passenger trips: #{passenger.trips.length}"
# puts "Final driver trips : #{actual_driver.trips.length}"
#

##############################################################

# dispatcher = RideShare::TripDispatcher.new
#
# trip = dispatcher.trips[1]
# puts trip.start_time
# puts trip.end_time
# puts trip.duration

# puts "Passenger ID: #{passenger.id}"
# puts dispatcher.trips.length
# puts new_trip.driver.id
# puts new_trip.passenger.id
# puts new_trip.
# driver = dispatcher.drivers[8]
# #
# puts driver.total_revenue
#
# driver.trips.each do |trip|
#   times = trip.duration
#   puts times
# end
# #
# #
# puts "Total revenue_per_hour: #{driver.total_revenue_per_hour}"
# puts passenger.name
# puts passenger.calculate_total_trips_duration

# puts passenger.calculate_total_money_spent
# # binding.pry
# dispatcher = RideShare::TripDispatcher.new
# puts dispatcher.load_passengers[0]
# puts dispatcher.load_trips
# puts dispatcher.trips[0].start_time
# puts dispatcher.trips[0].start_time.class
# puts dispatcher.trips[0].start_time.to_r
# puts dispatcher.trips[0].class
