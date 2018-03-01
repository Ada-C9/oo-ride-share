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
      #checkid method for each driver(in this class)
      check_id(id)
      #for each driver in instance variable for TripDispenser instance, assign their id ?
      #if true
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
      #check passenger id
      check_id(id)
      #for each passenger in instance variable of dispatcher id is passenger id
      #finds first result in @passenger instance variable
      #if true
      @passengers.find{ |passenger| passenger.id == id }
    end

    #????Go over this
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



    def request_trip(passenger_id)
      check_id(passenger_id)
      passenger = @passengers.find{ |passenger| passenger.id == passenger_id }

      #Your code should automatically assign a driver to the trip
      check_status(driver)
      driver = @drivers.find{ |driver| driver.status == :AVAILABLE }
      passenger = @passengers.find{ |passenger| passenger.id == passenger_id }
      puts passenger

      #For this initial version, choose the first driver whose status is :AVAILABLE
      #goes through drivers and finds one who is available alldrivers.each do |status|
      #if status == :AVAILABLE
      #IS DRIVER
      #end
      #this needs to be able to change- how will it change, to pick the driver with the least trips eg

      #Your code should use the current time for the start time

      #The end date, cost and rating will all be nil
      #instance of trip- calling it in dispatcher
      in_progress_data = {
        id: 0,
        driver: driver,
        passenger: passenger,
        start_time: Time.now,
        end_time:nil,
        cost:nil,
        rating:nil,
      }
      #call an instance of trip in dispatcher

      unfinished_trip = RideShare::Trip.new(in_progress_data)

      driver.avaialable?(false)
      driver.add_trip(unfinished_trip)
      passenger.add_trip(unfinished_trip)
      trips.push(unfinished_trip)
      #passenger.add_trip(unfinished_trip)
      #how do these instances not write over each other?
      return unfinished_trip
    end

    private

    def trip_time
      return trip[:start_time] - trip[:endtime]
    end

    def check_id(id)
      if id == nil || id <= 0
        raise ArgumentError.new("ID cannot be blank or less than zero. (got #{id})")
      end
    end

    def check_status
      if @drivers.all?{ |driver| driver.status == :UNAVAILABLE}
        raise ArgumentError.new("No available drivers")
      end
    end

  end
end
#
# #puts trips.length
# dispatcher = RideShare::TripDispatcher.new
# yet_trip =  dispatcher.request_trip(9)
#
#
# puts yet_trip.id
# puts yet_trip.driver
# puts yet_trip.passenger
# puts yet_trip.start_time
# puts yet_trip.end_time
# puts yet_trip.cost
# puts yet_trip.rating
# puts yet_trip.driver.status
# puts yet_trip.driver.trips
# puts "*********"
# puts yet_trip.passenger.trips
# #puts yet_trip.length
