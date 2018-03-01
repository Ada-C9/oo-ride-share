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

    def get_total_rev
      total_rev = 0
      @trips.each do |trip|
        trip_total = (trip.cost - 1.65) * 0.8
        total_rev += trip_total
      end

      return total_rev
    end

    def tot_drive_time
      tot_time = 0
      @trips.each do |trip|
        tot_time += trip.duration
      end
    end

    def avg_total_rev # per hour
      avg_total_rev = 0
      # get total amount of time driven by driver
      # divide total trip rev by tot_time_spent in hours
    end

  end
end
