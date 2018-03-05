require 'csv'
require 'time'
require 'money'

module RideShare
  class Trip
    attr_reader :id, :passenger, :driver, :start_time, :end_time, :cost, :rating

    def initialize(input)
      @id = RideShare.return_valid_id_or_error(input[:id])
      @driver = RideShare.return_valid_driver_or_error(input[:driver])
      @passenger = valid_passenger_or_error(input[:passenger])
      @start_time = valid_time_or_error(input[:start_time])
      @end_time = valid_end_time_or_error(input[:end_time])
      @cost = valid_cost_or_error(input[:cost])
      @rating = valid_rating_or_error(input[:rating])
      valid_in_progress_or_not
      valid_trip_duration_or_error
    end

    # If trip is not in-progress, returns the trip duration in seconds.
    # Otherwise returns 'nil'.
    def get_duration
      return (@end_time - @start_time).to_i if !is_in_progress?
    end

    # Returns 'true' if the trip is in progress and 'false' otherwise.
    def is_in_progress?
      return @end_time.nil?
    end

    private

    def valid_in_progress_or_not
      if is_in_progress? && (!@cost.nil? || !@rating.nil?)
        raise ArgumentError.new("Invalid in-progress trip")
      end
      if !is_in_progress? && @cost.nil? && @rating.nil?
        raise ArgumentError.new("Invalid completes trip")
      end
    end

    # Throws ArgumentError if trip is not in progress and provided ta is provided rating
    def valid_rating_or_error(rating)
      # rating must be nil if trip is in progress.
      if !is_in_progress? && (rating.class != Integer || !rating.between?(1, 5))
        raise ArgumentError.new("Invalid rating #{rating}")
      end
      return rating
    end

    def valid_trip_duration_or_error
      if !is_in_progress? && get_duration < 0.0
        raise ArgumentError.new("Invalid duration #{get_duration}")
      end
    end

    def valid_passenger_or_error(input_passenger)
      if input_passenger.class != Passenger
        raise ArgumentError.new("Invalid passenger #{input_passenger}")
      end
      return input_passenger
    end

    def valid_end_time_or_error(time)
      valid_time_or_error(time) if !time.nil?
      return time
    end

    def valid_time_or_error(time)
      if time.class != Time
        raise ArgumentError.new("Invalid time #{time}")
      end
      return time
    end

    def valid_cost_or_error(initial_cost)
      if !is_in_progress? && !is_valid_money_amount?(initial_cost)
        raise ArgumentError.new("Invalid cost #{initial_cost}")
      end
      return initial_cost
    end

    def is_valid_money_amount?(money)
      return money.class == Float && (money == 0.0 || money >= 0.01)
    end

  end
end
