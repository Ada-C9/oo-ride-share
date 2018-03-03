require 'csv'
require_relative 'trip'

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

    def change_driver_status
      if @status == :UNAVAILABLE
        @status = :AVAILABLE
      elsif @status == :AVAILABLE
        @status = :UNAVAILABLE
      end
      return @status
    end
    


    def average_rating
      total_ratings = 0
      @trips.each do |trip|
        #unless trip.in_progress? == true
          total_ratings += trip.rating
        end
      #end


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
      takenhome = 0.8
      fee = 1.65
      revenue = 0
      @trips.each do |trip |
        ### What is the cost is less than the fee
        unless trip.in_progress? == true
          cost = trip.cost - fee
          revenue += cost
        end
      end
      total_rev = revenue * takenhome
      return total_rev
    end


    def time_driving_trips
      time_driving = 0
      @trips.each do |trip|
        unless trip.in_progress? == true
          time_driving += trip.trip_duration
        end
      end
      return time_driving
    end

    def average_revenue_hour
      time_driving_hours = time_driving_trips / 60 / 60
      return (total_revenue/time_driving_hours).round(2)
    end
  end
end
