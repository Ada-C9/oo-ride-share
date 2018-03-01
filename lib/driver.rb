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

    def calculate_total_rev()
      total_rev = @trips.inject(0) do |total, trip|
        trip_cost = trip.cost
        trip_cost > 1.65 ? trip_cost -= 1.65 : trip_cost
        total + trip_cost
      end
      return total_rev
    end

    def total_drive_time()
      total_time = @trips.inject(0) do |total, trip|
         total + trip.calculate_duration
      end
      return total_time
    end

    def avg_rev_per_hour()
      total_time_in_min = total_drive_time / 60.0
      total_time_in_hr = total_time_in_min / 60.0

      avg_rev = calculate_total_rev / total_time_in_hr
      return avg_rev
    end
  end
end
