require 'csv'
require 'time'
require 'pry'

module RideShare
  class Trip
    attr_reader :id, :passenger, :driver, :cost, :rating, :start_time, :end_time

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

      if @end_time < @start_time
        raise ArgumentError.new("End time must occur after start time.")
      end
    end

    def duration
      return @end_time - @start_time
    end

  end
end
