require 'csv'

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
      end # rating

      if @end_time < @start_time
        raise ArgumentError.new("Invalid end time")
      end #end<start
    end #initialize

    def duration
    # calculate the duration of the trip in seconds
    duration = (@end_time - @start_time)
    return duration
    end

  end # Class trip
end # Module
