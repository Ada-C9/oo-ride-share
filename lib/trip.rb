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

      if @rating != nil && (@rating > 5 || @rating < 1)
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

      if @end_time != nil && @start_time > @end_time
        raise ArgumentError.new("Invalid: Time elapsed cannot be negative.")
      end

    end

    def duration
      if @end_time != nil && @end_time > @start_time
        ( @end_time - @start_time )
      else
        return nil
      end
    end

  end
end
