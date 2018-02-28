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

    def total_rev
      total_rev = 0
      @trips.each {|trip| total_rev +=  (trip.cost - 1.65) * 0.8}
      return total_rev
    end

  end
end

# 3. Add an instance method to Driver to calculate that driver's total revenue across all their trips. Each driver gets 80% of the trip cost after a fee of $1.65 is subtracted.

# Dee's  Pseudocode:

# get toal rev method
# total_rev starts at 0
#
# iterate through each trip in all_trips
#   fee is 1.65
#   trip_cost
#   trip_rev is (trip_cost - fee) * 0.8
#   trip_rev adds to total_rev
#
#
# return total_rev
