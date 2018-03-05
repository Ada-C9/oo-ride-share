require 'csv'
require 'time'

module RideShare
  class Trip
    attr_reader :id, :passenger, :driver, :start_time, :end_time, :cost, :rating

    def initialize(input)
      @id = RideShare.return_valid_id_or_error(input[:id])
      @driver = RideShare.return_valid_driver_or_error(input[:driver])
      @passenger = input[:passenger]
      @start_time = valid_time_or_error(input[:start_time])
      @end_time = input[:end_time]
      @cost = input[:cost]
      @rating = valid_rating_or_error(input[:rating])
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

    def valid_time_or_error(time)
      if time.class != Time
        raise ArgumentError.new("Invalid time #{time}")
      end
      return time
    end

    def valid_cost(initial_cost)
      if initial_cost.class != Double || initial_cost >= 0.00
        raise ArgumentError.new("Invalid cost #{initial_cost}")
      end
      return time
    end

  end
end
