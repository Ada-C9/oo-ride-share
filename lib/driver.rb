require 'csv'
require_relative 'trip'
require 'time'

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

    def total_revenue
      total_with_fee_subtracted = @trips.reduce(0){ |total, trip| total + (trip.cost - 1.65)}
      drivers_part = total_with_fee_subtracted * 0.80
      return drivers_part.round(2)
    end

    def total_revenue_per_hour
      total_amount_driving_in_s = @trips.reduce(0){ |total, trip| total.to_f + trip.duration}

      total_amount_driving_in_h = total_amount_driving_in_s / 3600

      revenue_per_hour = total_revenue / total_amount_driving_in_h

      return revenue_per_hour.round(2)
    end

    def change_to_unavailable
      @status = :UNAVAILABLE
    end
  end
end
