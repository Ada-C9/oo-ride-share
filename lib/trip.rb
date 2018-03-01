require 'csv'
require 'time'
require 'pry'

module RideShare
  class Trip
    attr_reader :id, :passenger, :driver, :cost, :rating
    attr_accessor :start_time, :end_time

    def initialize(input)
      @id = input[:id]
      @driver = input[:driver]
      @passenger = input[:passenger]
      @start_time = Time.parse(input[:start_time])
      @end_time = Time.parse(input[:end_time])
      @cost = input[:cost]
      @rating = input[:rating]

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

      current_time = Time.now

      if @end_time < @start_time || @start_time > current_time || @end_time > current_time
        raise ArgumentError.new("Trips must start before then end. Trips must also start and end in the past.")
      end
    end

    def duration
      trip_duration = @end_time - @start_time
      if trip_duration < 0
        raise ArgumentError.new("Trips must start before then end.")
      else
        return trip_duration
      end
    end

  end
end
