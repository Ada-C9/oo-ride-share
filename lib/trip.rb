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

    def self.total_time(trip_list)
      total_time = 0
      trip_list.each do |trip|
       total_time += trip.duration
      end
      return total_time
    end

  end # Class trip
end # Module
