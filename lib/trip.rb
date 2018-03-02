require 'csv'
require 'time'
module RideShare
  class Trip
    attr_reader :id, :passenger, :driver, :start_time, :end_time, :cost, :rating

    def initialize(input)
      @id = input[:id]
      @driver = input[:driver]
      @passenger = input[:passenger]
      @start_time = Time.parse(input[:start_time])
      @end_time = Time.parse(input[:end_time]) if input[:end_time]
      @cost = input[:cost]
      @rating = input[:rating]

      if !valid_rating?
        raise ArgumentError.new("Invalid rating #{@rating}")
      end
    end

    def trip_duration
      if ((@end_time - @start_time) / 60 ).to_i < 0
        raise ArgumentError.new "Invalid trip duration, Trip must begin before it can end."
      else
        return ((@end_time - @start_time) / 60 ).to_i
      end
    end


    private
    def valid_rating?
      return true if end_time.nil?

      return @rating != nil &&
             @rating <= 5 &&
             @rating >= 1


    end


  end
end
