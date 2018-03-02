require 'csv'
require_relative 'trip'

module RideShare
  class Driver
    attr_reader :id, :name, :vehicle_id, :status , :trips

    def initialize(input)

      raise ArgumentError.new("ID cannot be blank or less than zero. (got #{input[:id]})")  if input[:id] == nil || input[:id] <= 0

      raise ArgumentError.new("VIN cannot be less than 17 characters.  (got #{input[:vin]})")  if input[:vin] == nil || input[:vin].length != 17

      @id = input[:id]
      @name = input[:name]
      @vehicle_id = input[:vin]
      @status = input[:status] == nil ? :AVAILABLE : input[:status]
      @trips = input[:trips] == nil ? [] : input[:trips]
    end

    def average_rating
      # Driver's avarage rating:
      total_ratings = 0
      @trips.each {|trip| total_ratings += trip.rating}

      return average = trips.length == 0 ? average = 0 : average = (total_ratings.to_f) / trips.length
    end

    def add_trip(trip)
      raise ArgumentError.new("Can only add trip instance to trip collection")  if trip.class != Trip
      @trips << trip
    end

    def average_revenue
      # Driver's avarage revenue in hours:
      total_hours = total_time_in_trips
      total_hours > 0 ?  (total_rev / (total_hours/3600))  :  0
    end

    def total_rev
      # Calculates the total revenue per hour:
      total_rev = 0
      @trips.each {|trip| trip.end_time == nil ?   total_rev += 0 : total_rev += ((trip.cost - 1.65) * 0.8)}
      return total_rev
    end

    def total_time_in_trips
      # Calculates the total hours of all trips, ignoring the in-progress ones:
      total_hours = 0
      @trips.each {|trip| trip.end_time == nil ? total_hours += 0 : total_hours += trip.trip_duration}
      return total_hours
    end

    def change_status
      @status = :UNAVAILABLE
    end

  end
end
