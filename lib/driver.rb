require 'csv'
require_relative 'trip'

module RideShare
  class Driver
    attr_reader :id, :name, :vehicle_id, :status, :trips

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

    # Charles did this in Group Review on 28 Feb 2018
    # def passengers
    #   # EACH STYLE
    #   # passenger = []
    #   # trips.each do |trip| # <-- trip is an instance of the Trip class
    #   #   passengers << trip.passenger
    #   # end
    #   # return passengers.uniq # <- deals with duplicates
    #   #
    #   # MAP STYLE
    #   passengers = trips.map do |trip|
    #     trip.passenger # <-- does the shoveling in for us on its own
    #   end
    #   return passengers.uniq
    # end


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
      #   raise ArgumentError.new("Can only add trip instance to trip collection")
      # end
      # Charles suggests this change in Group Review on Feb 28 2018
      unless trip.class <= Trip
        raise ArgumentError.new("Can only add trip instance to trip collection")
      end
      @status = :UNAVAILABLE
      @trips << trip
    end # ends "def add_trip"

    # For a given driver, calculate their total revenue for all trips. Each driver gets 80% of the trip cost after a fee of $1.65 is subtracted.
    def total_revenue
      fee = 1.65
      subtotal = 0 # (it's really total_revenue and starts at zero)
      driver_take_home = 0.8

      @trips.each do |trip|
        subtotal += trip.cost - fee
      end

      # (Question: write this test: what if the trip costs less than the 1.65 fee?)
      # make an instance of trip that doesn't exist??? to test this???

      total = subtotal * driver_take_home
      return total
    end

  end # ends class Driver
end # ends module RideShare
