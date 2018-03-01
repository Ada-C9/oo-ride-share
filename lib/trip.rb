require 'csv'
require 'time'

module RideShare
  class Trip
    attr_reader :id, :passenger, :driver, :start_time, :end_time, :cost, :rating

    def initialize(input)
      @id = input[:id]
      @driver = input[:driver]
      @passenger = input[:passenger]
      @start_time = input[:start_time]
      @end_time = input[:end_time]
      @cost = input[:cost]
      @rating = input[:rating]

      if @rating == nil
      elsif @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

      if @end_time == nil
      elsif @start_time > @end_time
        raise ArgumentError.new("Invalid start and end time input. End time before start time.")
      end

    end

    # should be unable to calc duration if end_time == nil
    def duration
      if @end_time.nil?
        raise StandardError.new("Cannot calculate trip duration. Trip is still in progress.")
      else
        time_in_seconds = @end_time - @start_time
        time_in_hours = time_in_seconds / 3600
      end
    end

  end
end
