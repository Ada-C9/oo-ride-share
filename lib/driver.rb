require 'csv'
require_relative 'trip'

require 'pry'

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
      if trip.class != Trip
        raise ArgumentError.new("Can only add trip instance to trip collection")
      end

      @trips << trip
    end

    # For a given driver, calculate their total revenue for all trips. Each driver gets 80% of the trip cost after a fee of $1.65 is subtracted.

    # get total rev method
    # total rev starts at 0
    # returns total_rev
    # interate though all trips
    # each trip sub the fee (1.65)
    # then trip *0.8
    # sum of all trips
# TODO: figure out why @trips is not an Array
    def get_total_rev
      total_rev = 0
      # binding.pry
      @trips.each do |trip|
        trip_total = (trip.cost - 1.65) * 0.8
        total_rev += trip_total
      end

      return total_rev
    end

  end
end
