require 'csv'
require_relative 'trip'

module RideShare
  class Driver
    attr_reader :id, :name, :vehicle_id, :trips
    attr_accessor :status

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
      @status = input[:status] == nil ? :AVAILABLE : input[:status] # default status set to AVAILABLE

      @trips = input[:trips] == nil ? [] : input[:trips] #trips are objects in an array
      @total_revenue = total_revenue
    end

    def completed_trips
      @trips.find_all do |trip|
        trip.end_time != nil && trip.rating != nil && trip.cost != nil
      end
    end

    def average_rating

      total_ratings = 0
      self.completed_trips.each do |trip|
        total_ratings += trip.rating
      end

      if completed_trips.length == 0
        average = 0
      else
        average = (total_ratings.to_f) / completed_trips.length
      end

      return average
    end

    def add_trip(trip)
      if trip.class != Trip
        # unless trip.class <= Trip # if Trip not a subclass of trip then not permissible
        raise ArgumentError.new("Can only add trip instance to trip collection")
      end

      @trips << trip
    end

    def total_revenue
      # total_revenue = 0 replaced by trip.cost
      fee = 1.65
      driver_share = 0.8

      subtotal = 0
      completed_trips.each do |trip|
        subtotal += trip.cost - fee
      end

      total = subtotal * driver_share
      return total.to_f
    end

    def avg_revenue
      avg_revenue = (total_revenue/trips.length)
      return avg_revenue_per_hr = (avg_revenue/60).round(2)
    end
  end
end
