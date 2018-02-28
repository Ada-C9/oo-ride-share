require 'csv'
require 'time'
require 'pry'

module RideShare
  class Trip
    attr_reader :id, :passenger, :driver, :start_time, :end_time, :cost, :rating

    def initialize(input)
      @id = input[:id]
      @driver = input[:driver]
      @passenger = input[:passenger]
      @start_time = valid_time_or_error(input[:start_time])
      @end_time = valid_time_or_error(input[:end_time])
      @cost = input[:cost]
      @rating = valid_rating_or_error(input[:rating])
      valid_trip_duration_or_error
    end

    def get_duration
      return (@end_time - @start_time).to_i
    end

    private

    def valid_rating_or_error(rating)
      if rating > 5 || rating < 1
        raise ArgumentError.new("Invalid rating #{rating}")
      end
      return rating
    end

    def valid_trip_duration_or_error
      if get_duration < 0.0
        raise ArgumentError.new("Invalid duration #{get_duration}")
      end
    end

    def valid_time_or_error(input_time)
      if input_time.class != Time
        raise ArgumentError.new("Invalid time #{input_time}")
      end
      return input_time
    end


  end
end
