require 'csv'

module RideShare
  class Driver

    TRIP_FEE = 1.65

    attr_reader :id, :name, :vehicle_id, :status, :trips


    def initialize(input)
      @id = RideShare.return_valid_id_or_error(input[:id])
      @name = RideShare.return_valid_name_or_error(input[:name])
      @vehicle_id = return_valid_vin_or_error(input[:vin])
      @status = return_valid_status_or_error(input[:status])
      @trips = set_valid_trips_or_errors(input[:trips])
    end

    # Throws ArgumentError is provided trip is not a trip or if the trip is in
    # progress but the driver is unavailable.
    # Adds trip to trips and sets status to unavailable if trip is in progress.
    def add_trip(trip)
      RideShare.return_valid_trip_or_error(trip)
      check_and_update_status if trip.is_in_progress?
      @trips << trip
    end

    def get_average_rating
      num_of_trips = get_num_of_completed_trips
      return num_of_trips == 0 ? 0 : (get_ratings.to_f / num_of_trips)
    end

    # Returns the total revenue of all completed trips.
    def get_total_revenue
      return calculate_total_revenue
    end

    # Returns the total revenue of all completed trips.
    def get_avg_revenue_per_hour
      avg_rev = (get_total_revenue / get_total_trip_durations_in_hours).round(2)
      return avg_rev.nan? ? 0.0 : avg_rev
    end

    # Returns 'true' if status is available and 'false' otherwise.
    def is_available?
      return @status == :AVAILABLE
    end

    private

    # Throws ArgumentError if input_trips is not 'nil' or an array of Trips, if
    # input_trips has more than one in-progress trip, or if input_trips has an
    # in-progress trip but status is 'AVAILABLE'.
    #
    # Returns an empty array if provided input_trips is 'nil'. Otherwise,
    # returns input_trips.
    def set_valid_trips_or_errors(input_trips)
      valid_trips = RideShare.return_valid_trips_or_errors(input_trips)
      check_num_of_in_progress_trips(valid_trips)
      return valid_trips
    end

    # Counts the number of in-progress trips in provided valid_trips and throws
    # ArgumentError if valid_trips has more than one in-progress trip or if
    # valid_trips has an in-progress trip but status is 'AVAILABLE'.
    def check_num_of_in_progress_trips(valid_trips)
      num_of_in_progress = 0
      valid_trips.each do |trip|
        num_of_in_progress += 1 if trip.is_in_progress?
        break if num_of_in_progress > 1
      end
      check_for_in_progress_error(num_of_in_progress) if num_of_in_progress > 0
    end

    #
    def check_for_in_progress_error(num_of_in_progress)
      if num_of_in_progress == 1 && is_available?
        raise ArgumentError.new("Error in driver's initial status or trips")
      end
      if num_of_in_progress > 1
        raise ArgumentError.new("Cannot have multiple in-progress trips.")
      end
    end

    # Throws ArgumentError if status is unavailable. Otherwise, sets status to
    # 'UNAVAILABLE'.
    def check_and_update_status
      if !is_available?
        raise ArgumentError.new("Driver unavailable for in-progress trip.")
      end
      @status = :UNAVAILABLE
    end

    # Return the amount earned for all completed trips.
    def calculate_total_revenue
      return @trips.inject(0.0) do |sum, trip|
        trip.is_in_progress? ? sum + 0 : sum + calculate_pay(trip.cost)
      end
    end

    # Provided trip_cost must be the cost of a trip in dollars.
    # Returns the amount in dollars the
    def calculate_pay(trip_cost)
      return trip_cost >= TRIP_FEE ? (trip_cost - TRIP_FEE) * 0.80 : 0.0
    end

    # Returns the trip durations in hours.
    def get_total_trip_durations_in_hours
      return RideShare.get_all_trip_durations_in_seconds(trips).to_f / 60 / 60
    end

    #
    def get_ratings
      return @trips.inject(0) do |sum, trip|
        trip.is_in_progress? ? sum + 0 : sum + trip.rating
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

    def return_valid_status_or_error(input_status)
      return :AVAILABLE if input_status.nil?
      if input_status != :AVAILABLE  && input_status != :UNAVAILABLE
        raise ArgumentError.new("Status must be AVAILABLE or UNAVAILABLE.")
      end
      return input_status
    end
  end
end
