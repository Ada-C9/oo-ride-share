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
        vin = line[2].length == 17 ? line[2] : "0" * 17  # Set to default value

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
      return find_by_id(@drivers, id)
      # check_id(id)
      # return @drivers.find{ |driver| driver.id == id }
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
      return find_by_id(@passengers, id)
      # check_id(id)
      # return @passengers.find{ |passenger| passenger.id == id }
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
        trips << make_new_trip(parsed_trip) #trip
      end

      return trips
    end

    def request_trip(passenger_id)
      driver = find_available_driver
      return if driver.nil?
      trip_id = @trips.empty? ? 1 : @trips.size
      new_trip_data = {
        id: trip_id,
        driver: driver,
        passenger: find_passenger(passenger_id),
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil
      }

      new_trip = make_new_trip(new_trip_data)
      @trips << new_trip
      return new_trip
    end

    private

    # Provided list_to_search must be a list of Drivers, Trips, or Passengers.
    def find_by_id(list_to_search, id)
      RideShare.return_valid_id_or_error(id)
      return list_to_search.find{ |element| element.id == id }
    end

    def make_new_trip(new_trip_data)
      trip = Trip.new(new_trip_data)
      trip.driver.add_trip(trip)
      trip.passenger.add_trip(trip)
      return trip
    end

    def find_available_driver
      return @drivers.find {|driver| driver.is_available? }
    end
  end
end
