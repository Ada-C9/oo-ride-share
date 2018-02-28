require 'csv'
require 'pry'
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
        next if trip.rating == nil
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
      subtotal = 0
      fee = 1.65
      driver_cut = 0.8
      @trips.each do |trip|
        unless trip.cost <= fee
          subtotal += (trip.cost - fee)
        else
          subtotal += 0
        end
      end
      total = subtotal * driver_cut
      return total.round(2)
    end

    def total_hours
      total_seconds = 0
      @trips.each do |trip|
        total_seconds += trip.trip_duration
      end
      total_hours = total_seconds.to_f / 3600
      return total_hours.round(2)
    end

    def avg_revenue
      return total_hours == 0 ? 0 : (total_revenue/total_hours).round(2)
    end

  end # Driver
end # RideShare

# binding.pry
