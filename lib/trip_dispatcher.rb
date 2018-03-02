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
          start_time: Time.new(raw_trip[:start_time]),
          end_time: Time.new(raw_trip[:end_time]),
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

    def find_available_drivers
      @drivers.find{ |driver| driver.status == :AVAILABLE }
    end

    def request_trip(passenger_id)
      check_id(passenger_id)
      #@drivers.find{ |driver| driver.status == AVAILABLE }
      @trip_data  = {
        id: ((@trips.map{ |t| t.id }).max) + 1,
        driver: find_available_drivers.id,
        passenger: passenger_id,
        start_time: Time.now,
        end_time: nil, #Time.now + 60, ## Remember to update
        cost: nil, #0.01,
        rating: nil, #3
      }
      @trip = RideShare::Trip.new(@trip_data)
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
puts puts
dispatcher = RideShare::TripDispatcher.new

# puts dispatcher
# print dispatcher.load_trips.first.passenger.name
# puts puts
# puts puts
#
# puts dispatcher.find_available_drivers.id
# puts dispatcher.find_available_drivers.name
# #puts dispatcher.output_next_available_driver_id
# puts puts
# print
# puts puts
# puts Time.now
# puts Time.now + 60
# puts Time.parse('2015-05-20T12:14:00+00:00')
# #print dispatcher.find_max_id
# puts puts
# puts dispatcher.request_trip(1).driver
