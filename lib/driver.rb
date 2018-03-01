require 'csv'
require_relative 'trip'
require 'pry'

module RideShare
  class Driver
    attr_reader :id, :name, :vehicle_id, :trips, :total_rev, :driving_time
    attr_accessor :status

    def initialize(input)
      if input[:id] == nil || input[:id] <= 0
        raise ArgumentError.new("ID cannot be blank or less than zero. (got #{input[:id]})")
      end

      unless input[:vin] == nil
        if input[:vin].length != 17
        raise ArgumentError.new("VIN cannot be less than 17 characters.  (got #{input[:vin]})")
        end
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

    def total_revenue
      @total_rev = 0
      @trips.each do |trip|
        price = trip.cost - 1.65
        price *= 0.8
      @total_rev += price.round(2)
      end

      return @total_rev
    end

    def driving_time
      @driving_time = 0
      @trips.each do |trip|
        @driving_time += trip.duration
      end
      return @driving_time
    end

    def average_revenue
      driving_time
      total_revenue

      average_rev = @total_rev / @driving_time
      average_rev *= 3600

      return average_rev
    end

    def update_info(trip)
      @status = :UNAVAILABLE
      add_trip(trip)
    end
  end
end
