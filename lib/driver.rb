require 'csv'
require_relative 'trip'

module RideShare
  class Driver
    attr_reader :id, :name, :vehicle_id, :status, :trips

    FEE_PER_TRIP = 1.65
    PERCENT_DRIVER = 0.80

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
      costs_array = @trips.collect do |trip|
        #In case one of the trips cost is less than the fee charged,
        #the cost of the trip will just be 0. To avoid negative revenues.
        if trip.cost < FEE_PER_TRIP
          0
        else
          trip.cost - FEE_PER_TRIP
        end
      end
      sub_total = costs_array.sum
      total_revenue = (sub_total) *(PERCENT_DRIVER)
      return total_revenue.round(2)

    end

    def average_revenue_per_hr
      if @trips == []
        return 0
      else
        seconds_array = @trips.collect do |trip|
          trip.trip_duration
        end
        hours = (seconds_array.sum)/(3600)
        average_revenue_per_hr = total_revenue/hours
        return average_revenue_per_hr.round(2)
      end
    end

    # helper method to modify his status 
    def unavailable
      @status = :UNAVAILABLE
    end
  end
end
