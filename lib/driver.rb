require 'csv'
require_relative 'trip'
require "pry"

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
      trips_in_progess = 0
      @trips.each do |trip|
        if trip.end_time != nil
          total_ratings += trip.rating
        else
          trips_in_progess += 1
        end
      end

      trips_with_ratings = trips.length - trips_in_progess

      if trips.length == 0
        average = 0
      else
          average = (total_ratings.to_f) / trips_with_ratings
      end

      return average

    end

    def add_trip(trip)
      if trip.class != Trip
        raise ArgumentError.new("Can only add trip instance to trip collection")
      end
      @trips << trip
    end

    def calculate_total_revenue
      total_revenue = 0
      fee = 1.65
      driver_take_home = 0.8
      @trips.each do |trip|
        if trip.end_time != nil
          subtotal = trip.cost - fee
          subtotal *= driver_take_home
          total_revenue += subtotal
        end
      end
      return total_revenue.to_f.round(2)
    end

    def calculate_total_trips_time_in_hours
      return 0 if trips.length == 0

      trip_time_lengths = []
      @trips.each do |trip|
        if trip.end_time != nil
          trip_duration = trip.end_time.to_f - trip.start_time.to_f
          trip_time_lengths << trip_duration
        end
      end
      total_time_in_sec = 0
      total_time_in_sec = trip_time_lengths.inject(:+)
      total_time_in_hours = total_time_in_sec / (60 * 60)

      return total_time_in_hours
    end

    def calculate_avg_revenue_per_hour

      return 0 if calculate_total_revenue == 0

      return 0 if calculate_total_trips_time_in_hours == 0

      hourly_rate = calculate_total_revenue / calculate_total_trips_time_in_hours

      hourly_rate = hourly_rate.round(2)
      return hourly_rate
    end

    def add_new_trip(new_trip)
      trips << new_trip

      change_status

    end

    def change_status
      if @status == :AVAILABLE
        @status = :UNAVAILABLE
      end
    end

  end # end of Driver
end # end of RideShare
