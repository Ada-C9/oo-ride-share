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
      total_trips = 0
      @trips.each do |trip|
        if trip.end_time != nil
          total_ratings += trip.rating
          total_trips += 1
        else
          total_ratings
          total_trips
        end
      end

      if total_trips == 0
        average = 0
      else
        average = (total_ratings.to_f) / total_trips
      end
      return average
    end

    def add_trip(trip)
      if trip.class != Trip
        raise ArgumentError.new("Can only add trip instance to trip collection")
      end
      @trips << trip
    end

    def calc_revenue
      revenue = 0

      @trips.each do |trip|
        if trip.end_time != nil
          revenue += (0.8 * (trip.cost-1.65))
        else
          revenue
        end
      end
      return revenue.to_f
    end

    def calc_avg_revenue
      total_duration = 0
      @trips.each do |trip|
        if trip.end_time != nil
          total_duration += trip.duration
        else
          total_duration
        end
      end

      if trips.length == 0
        avg_revenue = 0
      else
        avg_revenue = (((calc_revenue.to_f)*3600)/total_duration)
      end

    end

    def change_status
      if @status == :AVAILABLE
        @status = :UNAVAILABLE
      else @status == :UNAVAILABLE
        @status = :AVAILABLE
      end
    end

  end
end
