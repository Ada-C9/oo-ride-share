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
        if trip.rating.nil?
        else
          total_ratings += trip.rating
        end
      end

      trips_length = 0
      @trips.each do |trip|
        if trip.end_time.nil?
        else
          trips_length += 1
        end
      end

      if trips_length == 0
        average = 0
      else
        average = (total_ratings.to_f) / trips_length
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
      total_revenue = 0.0
      @trips.each do |trip|
        if trip.cost.nil?
        else
          total_revenue += trip.cost - 1.65
        end
      end
      total_revenue *= 0.80
      return total_revenue
    end

    def average_revenue
      return self.total_time_spent == 0.0 ? 0.00 : (self.total_revenue / self.total_time_spent).round(2)
    end

    def total_time_spent
      total_time_spent = 0.0
      @trips.each do |trip|
        if trip.end_time.nil?
        else
          total_time_spent += trip.duration
        end
      end
      return total_time_spent
    end

    def trip_count
      return @trips.length
    end

    def new_trip_change_status
      @status = :UNAVAILABLE
    end

  end
end
