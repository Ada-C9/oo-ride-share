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


      if @end_time != nil && @start_time != nil && @end_time < @start_time
        raise ArgumentError.new("Invalid times. Cannot have start time after end time.")
      end


      if @rating != nil && (@rating > 5 || @rating < 1)
        raise ArgumentError.new("Invalid rating #{@rating}")
      end
    end

    def duration
      if @end_time == nil
        return 0
      else
        return @end_time - @start_time
      end

    end # duration

  end # Class Trip
end # Module RideShare
