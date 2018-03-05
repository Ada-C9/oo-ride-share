require 'csv'
require_relative 'trip'

module RideShare
  class Driver
    attr_reader :id, :name, :vehicle_id, :trips
    attr_accessor :status

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

    def finished_trips
      @trips.select { |trip| trip.end_time != nil  }
    end # finished trips

    def average_rating
      total_ratings = 0
      finished_trips.each do |trip|
        total_ratings += trip.rating
      end

      if finished_trips.length == 0
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
      @trips.finished_trips.inject(0) {| sum , trip| sum + ((trip.cost - 1.65) * 0.8)}
      return total_revenue
    end

    def average_revenue
      @trips.empty? ? 0 : (total_revenue / @trips.finished_trips.length.round(2))
    end

    def change_status
      @status = :UNAVAILABLE
    end

  end
end
