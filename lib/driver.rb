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
      #is nil if avaialbe otherwise status
      @status = input[:status] == nil ? :AVAILABLE : input[:status]
      #is nil if empty array, otherwise trips
      @trips = input[:trips] == nil ? [] : input[:trips]
    end

    #for driver/trip
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

    #takes in Trip class to check parameter
    #adds trip to instance variable trips within driver class
    def add_trip(trip)
      if trip.class != Trip
        raise ArgumentError.new("Can only add trip instance to trip collection")
      end
      @trips << trip
    end

    def total_revenue

      if trips == []
        return 0
      else
        fee = 1.65
        driver_takehome = 0.8

        subtotal = 0
        trips.each do |trip|
          subtotal += trip.cost - fee
        end

        total = subtotal * driver_takehome
        return total
      end
    end

    def avg_revenue
      revenue = total_revenue
      number_of_trips = @trips.length
      average = revenue / number_of_trips
      return average
    end

    def available?(available)
      if available == false
        @status = :UNAVAILABLE
      elsif available == true
        @status = :AVAILABLE
      end
    end
  end
end
