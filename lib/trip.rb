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


      if @end_time.to_s < @start_time.to_s
        raise ArgumentError.new("Invalid times. Cannot have start time after end time.")
      end


      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end
    end

    def duration
      seconds = (@end_time - @start_time)*24*60*60
      return seconds
    end # duration

  end # Class Trip
end # Module RideShare
