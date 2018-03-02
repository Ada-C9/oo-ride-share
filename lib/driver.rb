require 'csv'
require_relative 'trip'

module RideShare
  class Driver
    attr_reader :id, :name, :vin, :status, :trips

    def initialize(input)
      if input[:id] == nil || input[:id] <= 0
        raise ArgumentError.new("ID cannot be blank or less than zero. (got #{input[:id]})")
      end
      if input[:vin] == nil || input[:vin].length != 17
        raise ArgumentError.new("VIN cannot be less than 17 characters.  (got #{input[:vin]})")
      end

      @id = input[:id]
      @name = input[:name]
      @vin = input[:vin]
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
      return 0 if @trips.empty?

      total_earning = 0
      @trips.each do |trip|
        if !trip.ignore
          total_earning += trip.cost
        end
      end
      total_revenue = (total_earning - 1.65) * 0.8

      return total_revenue <= 0 ? 0 : total_revenue.round(2)
    end

    def ave_rev_per_hr
      return 0 if total_revenue == 0

      total_duration = 0
      @trips.each do |trip|
        if !trip.ignore
          total_duration += trip.duration
        end
      end

      return (total_revenue / (total_duration / 3600.0)).round(2)
    end

    def set_status(status)
      @status = status
    end

  end
end
