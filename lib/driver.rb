require 'csv'
require_relative 'trip'
require 'pry'


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

    def net_income
      income = 0
      @trips.each do |trip|
        income += trip.cost
      end
      if income == 0
        net_income = income
      else
        net_income = (income - 1.65) * 0.8
      end
      return net_income
    end

    def hourly_pay
      driving_time_seconds = 0
      @trips.each do |trip|
        driving_time_seconds += trip.duration
      end

      if net_income != 0 && driving_time_seconds != 0
        hourly_pay = (net_income / (driving_time_seconds / 3600.0))
      else
        hourly_pay = 0
      end
      return hourly_pay
    end
  end
end
