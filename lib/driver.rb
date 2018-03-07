require 'csv'
require_relative 'trip'
require 'pry'

module RideShare
  class Driver
    attr_reader :id, :name, :vehicle_id, :trips

    # added :status to attr_accessor to test 'request_trip' method in trip_dispatcher_spec.rb
    attr_accessor :status

    def initialize(input)
      if input[:id] == nil || input[:id] <= 0
        raise ArgumentError.new("ID cannot be blank or less than zero. (got #{input[:id]})")
      end
      if input[:vin] == nil || input[:vin].length != 17
        raise ArgumentError.new("VIN cannot be less than 17 characters.  (got #{input[:vin]})")
      end

      @id = input[:id]
      @name = input[:name]
      @vehicle_id = input[:vin]
      @status = input[:status] == nil ? :AVAILABLE : input[:status]

      @trips = input[:trips] == nil ? [] : input[:trips]
    end # ends initialize

    def passengers
      passengers = trips.map do |trip| # <-- trip is an instance of the Trip class
        trip.passenger # <-- does the shoveling in for us on its own
      end
      return passengers.uniq
    end

    def average_rating
      total_ratings = 0
      @trips.each do |trip|
        total_ratings += trip.rating
      end
      if trips.length == 0
        average = 0
      else
        average = (total_ratings.to_f) / trips.length
      end
      return average
    end

    def add_trip(trip)
      # if trip.class != Trip
      unless trip.class <= Trip
        raise ArgumentError.new("Can only add trip instance to trip collection")
      end
      if trip.end_time == nil
        @status = :UNAVAILABLE
      end
      @trips << trip
    end # ends "add_trip" method

    def change_status
      if @status == :UNAVAILABLE
        @status == :AVAILABLE
      elsif @status == :AVAILABLE
        @status == :UNAVAILABLE
      end
    end # ends "change_status" method


    def total_revenue
      fee = 1.65
      subtotal = 0 # (it's really total_revenue and starts at zero)
      driver_take_home = 0.8

      @trips.each do |trip|
        subtotal += trip.cost - fee
      end

      # TODO Write this test, if time allows: what if the trip costs less than the 1.65 fee?)

      total = subtotal * driver_take_home
      return total
    end #ends "total_revenue" method


    def average_revenue
      (total_revenue/finished_trips.length).round(2)
    end

    def finished_trips
      trips_reject{|trip| trip.end_time == nil}
    end

  end # ends class Driver
end # ends module RideShare
