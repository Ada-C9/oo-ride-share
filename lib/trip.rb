require 'csv'
require "time"

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

      unless (@start_time || @end_time) == nil
        if @start_time > @end_time
          raise ArgumentError.new("This trip is not rigth, starting time should be before end time")
        end
      end

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end
    end

    def trip_duration
      duration = Time.parse(@end_time) - Time.parse(@start_time)
      return duration
    end

  end
end
