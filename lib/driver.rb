require 'csv'
require 'time'
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
      @status = input[:status] == nil ? :UNAVAILABLE : input[:status]
      @trips = input[:trips] == nil ? [] : input[:trips]
    end

    def in_progress
      return @trips.reject { |ride| ride.end_time == nil }
    end

    def average_rating
      total_ratings = 0
      in_progress.each do |trip|
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
      unless trip.class <= Trip
        raise ArgumentError.new("Can only add trip instance to trip collection")
      end
      # if trip.end_time.nil?
      #   @status == :UNAVAILABLE
      # end
      @trips << trip
    end

    def total_revenue
      fee = 1.65
      subtotal = 0
      driver_takehome = 0.8

      in_progress.each do |trip|
          subtotal += (trip.cost - fee)
        end
        total = (subtotal * driver_takehome).round(2)
      return total
    end

    def average_revenue
      fee = 1.65
      subtotal = 0
      driver_takehome = 0.8

      in_progress.each do |trip|
          subtotal += (trip.cost - fee)
        end
        total = (subtotal * driver_takehome).round(2)

      average = total / in_progress.length
      return average
    end

  end
end

# if trip.class != Trip (is a restrictive way to say not apart of the class)
