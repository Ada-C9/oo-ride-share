require 'csv'
require 'time'

require_relative 'driver'
require_relative 'passenger'
require_relative 'trip'

module RideShare
  class TripDispatcher
    attr_reader :passengers, :trips
    # :drivers moved from reader to accessor to make
    # certain tests possible.
    attr_accessor :drivers

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
        start_time = Time.parse(raw_trip[:start_time])
        end_time = Time.parse(raw_trip[:end_time])

        parsed_trip = {
          id: raw_trip[:id].to_i,
          driver: driver,
          passenger: passenger,
          start_time: start_time,
          end_time: end_time,
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

    def choose_available_driver
      @drivers.find { |driver|
        driver.status == :AVAILABLE
    }
    end



    def create_new_trip_id
      @trips.map(&:id).max + 1
      #If there's no available driver, I think I just want this
      #to return nil.  I'll put the error downstream, in
      #request_trip(passenger_id)
      #
    end

    def request_trip(passenger_id)
      # WAVE 3 note:  The driver selection mechanism prescribed in Wave 3 is actually happening in the helper method, find_available_driver, above.
      new_trip_data = {
        id: create_new_trip_id,
        driver: choose_available_driver,
        passenger: find_passenger(passenger_id),
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil,
      }
      # THIS is where I want the error to be thrown if
      # there's no driver available.  So it's after the
      # driver-check method, but before the new trip
      # is made here. Single responsibility, yo: A lack
      # of a suitable driver should break the trip-generating
      # apparatus, not the searching apparatus.
      new_trip = RideShare::Trip.new(new_trip_data)
      if new_trip.driver == nil
        raise StandardError.new("Alas, no drivers are available at this time. Please try again later.")
      end

      @trips << new_trip
      choose_available_driver.accept_new_trip_assignment(new_trip)
      find_passenger(passenger_id).log_newly_requested_trip(new_trip)
      return new_trip
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
