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

    def get_average_rating
      total_ratings = 0
      finished_trips.each do |trip|
        total_ratings += trip.rating
      end

      if trips.length == 0
        average = 0
      else
        average = (total_ratings.to_f) / trips.length
      end

      return average.to_f
    end

    def add_trip(trip)
      if trip.class != Trip
        raise ArgumentError.new("Can only add trip instance to trip collection")
      end

      @trips << trip
    end

    def finished_trips
      trips_closed = @trips
      trips_closed.each do |trip|
        if trip.end_time == nil || trip.cost == nil || trip.rating == nil
          trips_closed.delete(trip)
        end
      end

      return trips_closed
    end

    def calculate_total_revenue
      fee = 1.65
      driver_portion = 0.8
      subtotal = finished_trips.map{ |trip| trip.cost - fee}.inject(0, :+).round(2)

      raise StandardError.new("Negative revenue") if subtotal < 0

      return subtotal * driver_portion
    end

    def calculate_average_revenue
      hour_to_second = 3600
      total_duration = finished_trips.map {|trip| trip.duration}.inject(0, :+) / hour_to_second

      return (calculate_total_revenue / total_duration).round(2)
    end

    def add_new_trip(trip)
      @trips << trip
      @status = :UNAVAILABLE
    end

    def find_most_recent_trip
      finished_trips.max_by {|trip| trip.end_time}
    end

  end
end
