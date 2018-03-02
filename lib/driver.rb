require 'csv'
require_relative 'trip'
require 'pry'
require 'awesome_print'

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

    def passengers
      # EACH STYLE
      # passengers = []
      # trips.each do |trip|
      #   passengers << trip.passenger
      # end

      # MAP STYLE
      passengers = trips.map do |trip|
        trip.passenger
      end
      return passengers
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


      if trip.end_time == nil
        accept_trip
      end

      @trips << trip

    end

    def accept_trip
      @status = :UNAVAILABLE
      return status
    end

    def total_revenue
      driver_revenue = 0
      @trips.each do |trip|
        if !(trip.end_time.nil?)
          driver_revenue += ((trip.cost - 1.65) * 0.8)
        end
      end
      return driver_revenue
    end

    def average_revenue_per_hour
      if @trips.length > 0
        driver_revenue = total_revenue / @trips.length
      else
        raise ArgumentError.new "No trips to provide revenue"
      end
    end
  end
end
