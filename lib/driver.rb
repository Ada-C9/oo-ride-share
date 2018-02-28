require 'csv'
require_relative 'trip'

module RideShare
  class Driver

    FEE = 1.65
    PERCENT_TAKEHOME = 0.8

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
      return trips.inject(0) {|sum, trip| sum += (trip.cost - FEE) * PERCENT_TAKEHOME}
    end

    def avg_revenue_per_hour
      revenue = total_revenue
      time_in_secs = trips.inject(0) {|sum, trip| sum += trip.duration_in_seconds}
      time_in_hours = (time_in_secs / 3600).round(2)
      if time_in_secs != 0
        return revenue / time_in_hours
      end
      return 0
    end
  end
end
