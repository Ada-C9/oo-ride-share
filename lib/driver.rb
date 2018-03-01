require 'csv'
require_relative 'trip'
require 'awesome_print'

module RideShare
  class Driver
    attr_reader :id, :name, :vehicle_id
    attr_accessor :status, :trips

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
        if trip.rating != nil
          total_ratings += trip.rating
        end
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
      total_revenue = 0
      @trips.each do |trip|
        if trip.cost != nil && trip.cost < 0
            total_revenue += 0
        elsif trip.cost != nil
          total_revenue += (trip.cost - 1.65) * 0.8
        end
      end
      return total_revenue.round(2)
    end

    def rate
      driving_time = 0
      @trips.each do |trip|
        if trip.end_time != nil
          driving_time += (trip.duration/3600) #in hours
        end
      end

      rate = (total_revenue/driving_time).round(2)
      return rate
    end

    def unavailable
      @status = :UNAVAILABLE
    end
  end
end


















#
