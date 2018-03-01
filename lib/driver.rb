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
      fee = 1.65
      driver_take_home = 0.8

      subtotal = 0
      trips.each do |trip|
        # Question: what if the cost is less than the fee
        if trip.cost < fee
          puts "#{trip.cost} < #{fee}"
          raise ArgumentError.new("Trip cost cannot be less then the trip fee (got #{trip.cost}.)")
        end
        subtotal += (trip.cost - fee)
      end
      total = subtotal * driver_take_home
      return total
    end
    # **W1: METHOD TO INSTITUE AVERAGE REVENUE PER HOUR METHOD-----------
    def av_revenue_hr
      trip_hours = 0
      total_hours = 0

      @trips.each do |trip|
        if trip.end_time != nil
          trip_hours = trip.duration / 3600
          total_hours += trip_hours
        end
      end
      av_revenue_hour = total_revenue / total_hours
      return av_revenue_hour
    end
    # **W1: METHOD TO INSTITUE AVERAGE REVENUE PER HOUR METHOD-----------
  end
end
