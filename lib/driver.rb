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

    def finished_trips
      trips.reject {|trip| trip.end_time == nil}
    end

    def average_rating
      total_ratings = 0
      finished_trips.each do |trip|
        total_ratings += trip.rating
      end

      if finished_trips.length == 0
        average = 0
      else
        average = (total_ratings.to_f) / finished_trips.length
      end

      return average
    end

    def add_trip(trip)
      unless trip.class <= Trip
        raise ArgumentError.new("Can only add trip instance to trip collection")
      end
      if trip.end_time == nil
        @status = :UNAVAILABLE
      end
      @trips << trip
    end

    def total_revenue
      fee = 1.65
      driver_takehome = 0.8

      subtotal = 0
      finished_trips.each do |trip|
        # Question: what if the cost is less than the fee
        subtotal += trip.cost - fee
      end

      total = subtotal * driver_takehome
      return total
    end

    def average_revenue
      (total_revenue / finished_trips.length).round(2)
    end
  end
end
