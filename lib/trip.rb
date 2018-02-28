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
      @start_time = input[:start_time]
      @end_time = input[:end_time]
      @cost = input[:cost]
      @rating = input[:rating]

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

      if @end_time.to_i < @start_time.to_i
        raise ArgumentError.new("End time (#{@end_time}) cannot be before start time (#{@start_time}).")
      end
    end

    def trip_duration?
      trip_seconds = @end_time.to_i - @start_time.to_i
      trip_hrs_round = (trip_seconds / 3600)
      trip_min_remdr_round = ((trip_seconds.to_i % 3600) / 60)
      trip_sec_remdr = ((trip_seconds.to_i % 3600) % 60)
      @duration_string = "#{trip_hrs_round} hour(s), #{trip_min_remdr_round} minute(s), #{trip_sec_remdr} second(s)."
    end
  end
end
