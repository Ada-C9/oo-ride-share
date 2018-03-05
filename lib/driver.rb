require 'csv'
require_relative 'trip'
require 'awesome_print'

module RideShare
  class Driver
    attr_reader :id, :name, :vehicle_id, :status, :trips
    attr_writer :status

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

    def set_status_unavailable
      @status.to_s
      @status == "UNAVAILABLE".to_sym
    end

    def total_revenue
      fee = 1.65
      total_revenue = 0
      @trips.each do |trip|
        trip = (trip.cost - fee) * 0.8
        total_revenue += trip
      end
      return total_revenue
    end

    def average_revenue_per_hour
      total_mins = 0
      @trips.each do |trip|
        trip = trip.end_time.min - trip.start_time.min
        total_mins += trip
      end
      total_hours = total_mins.to_f / 60
      return total_revenue / total_hours
    end

  end
end
