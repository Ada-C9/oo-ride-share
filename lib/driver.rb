require 'csv'
require 'time'
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
      @status = input[:status] == nil ? :UNAVAILABLE : input[:status]
      @trips = input[:trips] == nil ? [] : input[:trips]
    end

    def in_progress
      return @trips.reject { |ride| ride.end_time == nil }
    end

    def average_rating
      total_ratings = 0
      in_progress.each do |trip|
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
      unless trip.class <= Trip
        raise ArgumentError.new("Can only add trip instance to trip collection")
      end
      # >>>>>Do i need this code below?<<<<<<
      if trip.end_time.nil?
        @status == :UNAVAILABLE
      end
      # >>>>>>>> <<<<<<<<<<
      @trips << trip
    end

    def total_revenue
      fee = 1.65
      subtotal = 0
      driver_takehome = 0.8

      in_progress.each do |trip|
          subtotal += (trip.cost - fee)
        end
        total = (subtotal * driver_takehome).round(2)
      return total
    end

    def average_revenue
        average_per_hour = (total_revenue / in_progress.length) / (total_trip_duration / 3600)
      return average_per_hour.round(2)
    end

    def total_trip_duration
      total_time_seconds = 0
      in_progress.each do |trip|
        total_time_seconds += trip.duration
      end
      return total_time_seconds
    end

  end
end
