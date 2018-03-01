require 'csv'
require_relative 'trip'

module RideShare
  class Driver
    attr_reader :id, :name, :vehicle_id, :status, :trips

    def initialize(input)
      if input[:vin] == nil || input[:vin].length != 17
        raise ArgumentError.new("VIN cannot be less than 17 characters.  (got #{input[:vin]})")
      end

      @id = RideShare.return_valid_id_or_error(input[:id])
      @name = RideShare.return_valid_name_or_error(input[:name])
      @vehicle_id = input[:vin]
      @status = input[:status] == nil ? :AVAILABLE : input[:status]
      @trips = input[:trips] == nil ? [] : RideShare.valid_trips_or_errors(input[:trips])
    end

    def get_average_rating
      return 0 if trips.length == 0
      total_ratings = @trips.inject(0) { |total, trip| total + trip.rating }
      return (total_ratings.to_f) / trips.length
    end

    def add_trip(trip)
      RideShare.return_valid_trip_or_error(trip)
      check_and_update_status if trip.is_in_progress?
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

    def check_and_update_status
      if !is_available?
        raise ArgumentError.new("Cannot add in-progress trip to unavailable driver.")
      end
      @status = :UNAVAILABLE
    end

    def calculate_total_revenue
       return @trips.inject(0.0) do |total, trip|
         total + (trip.cost - 1.56) * 0.80 if !trip.is_in_progress?
       end
    end

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
