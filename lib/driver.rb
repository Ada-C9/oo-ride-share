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
      @status = :UNAVAILABLE
      @trips << trip
    end

    def total_revenue
      fee = 1.65
      take_home = 0.8
      subtotal = 0

      trips.each do |trip|
        subtotal += trip.cost - fee
      end
      total = subtotal * take_home
      return total
    end

    def total_hours
      trip_duration = 0

      trips.each do | trip |
        trip_duration += trip.duration
      end
      hours = trip_duration / (60 * 60)
      return hours
    end

    def average_revenue
      avg_rev = total_revenue / total_hours
    end
  end
end
