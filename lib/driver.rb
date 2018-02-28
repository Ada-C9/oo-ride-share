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
        if trip.end_time != nil
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

    def total_revenue
      subtotal = 0.0
      fee = 1.65
      take_home = 0.8

      @trips.each do |trip|
        if trip.end_time != nil
          subtotal += trip.cost - fee
        end
      end
      total = (subtotal * take_home).round(2)
    end

    def average_hourly_revenue
      trip_in_hours = 0.0
      total_hours = 0.0
      @trips.each do |trip|
        if trip.end_time != nil
        trip_in_hours = trip.trip_duration / 3600
        total_hours += trip_in_hours
        end 
      end
      average_hourly_revenue = self.total_revenue / total_hours
      # return average_hourly_revenue
    end

    def add_trip(trip)
      if trip.class != Trip
        raise ArgumentError.new("Can only add trip instance to trip collection")
      end

      @trips << trip
    end
  end
end
