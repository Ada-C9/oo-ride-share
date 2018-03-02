# QUESTION better to call public methods that call private methods or to call the
# private methods directly?

require 'csv'
require_relative 'trip'

module RideShare
  class Driver
    attr_reader :id, :name, :vehicle_id, :status, :trips

    def initialize(input)
      @id = RideShare.return_valid_id_or_error(input[:id])
      @name = RideShare.return_valid_name_or_error(input[:name])
      @vehicle_id = return_valid_vin_or_error(input[:vin])
      @status = input[:status] == nil ? :AVAILABLE : input[:status]
      @trips = RideShare.return_valid_trips_or_errors(input[:trips])
    end

    def get_average_rating # TODO: TEST!! # test if only trip is incomplete
      num_of_trips = get_num_of_completed_trips
      return num_of_trips == 0 ? 0 : (get_ratings.to_f / num_of_trips)
    end

    # Throws ArgumentError is provided trip is not a trip or if the trip is in
    # progress but the driver is unavailable.
    # Adds trip to trips and sets status to unavailable if trip is in progress.
    def add_trip(trip)
      RideShare.return_valid_trip_or_error(trip)
      check_and_update_status if trip.is_in_progress?
      @trips << trip
    end

    # Returns the total revenue of all completed trips.
    def get_total_revenue # TODO: TEST!!
      return calculate_total_revenue
    end

    # Returns the total revenue of all completed trips.
    def get_avg_revenue_per_hour # TODO: TEST!! # test if only trip is incomplete
      return (get_total_revenue / get_total_trip_durations_in_hours).round(2)
    end

    # Returns 'true' if status is available and 'false' otherwise.
    def is_available?
      return @status == :AVAILABLE
    end

    private

    # Throws ArgumentError if status is unavailable. Otherwise, sets status to
    # 'UNAVAILABLE'.
    def check_and_update_status
      if !is_available?
        raise ArgumentError.new("Driver unavailable for in-progress trip.")
      end
      @status = :UNAVAILABLE
    end

    def calculate_total_revenue
       return @trips.inject(0.0) do |total, trip|
         total + (trip.cost - 1.56) * 0.80 if !trip.is_in_progress?
       end
    end

    # Returns the trip durations in hours.
    def get_total_trip_durations_in_hours
      RideShare.get_all_trip_durations_in_seconds(trips).to_f / 120
    end

    #
    def get_ratings
      return @trips.inject(0) do |sum, trip|
        sum + trip.rating if !trip.is_in_progress?
      end
    end

    # Returns the number of completed trips.
    def get_num_of_completed_trips
      return @trips.length - 1 if !@trips.empty? && @trips.last.is_in_progress?
      return @trips.length
    end

    def return_valid_vin_or_error(input_vin)
      if input_vin.class != String || input_vin.length != 17
        raise ArgumentError.new("VIN #{input_vin} must be an int with length 17")
      end
      return input_vin
    end

  end
end
