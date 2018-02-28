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
      return 0 if trips.length == 0
      total_ratings = @trips.inject(0) { |total, trip| total + trip.rating }
      return (total_ratings.to_f) / trips.length
    end

    def add_trip(trip)
      if trip.class != Trip
        raise ArgumentError.new("Can only add trip instance to trip collection")
      end
      @status = :UNAVAILABLE if trip.end_time.nil? && is_available? 
      @trips << trip
    end

    def get_total_revenue
      return @trips.inject(0.0) { |total, trip| total + (trip.cost - 1.56) * 0.80 }
    end

    def get_avg_revenue_per_hour
      return (get_total_revenue / get_all_trip_durations).round(2)
    end

    def is_available?
      return @status == :AVAILABLE
    end

    private

    def get_all_trip_durations
      return @trips.inject(0) { |sum, trip| sum + trip.get_duration }.to_f / 120
    end

  end
end


# original average rating
# total_ratings = 0
# @trips.each do |trip|
#   total_ratings += trip.rating
# end
#
# if trips.length == 0
#   average = 0
# else
#   average = (total_ratings.to_f) / trips.length
# end
#
# return average
