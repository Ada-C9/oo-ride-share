require 'csv'
require 'time'

module RideShare
  class Trip
    attr_reader :id, :passenger, :driver, :start_time, :end_time, :cost, :rating

    def initialize(input)
      @id = input[:id]
      @driver = input[:driver]
      @passenger = input[:passenger]
      input[:start_time].nil? ? @start_time = nil : @start_time = Time.parse(input[:start_time])
      input[:end_time].nil? ? @end_time = nil : @end_time = Time.parse(input[:end_time])
      @cost = input[:cost]
      @rating = input[:rating]

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

      if @start_time == nil || @end_time == nil
        return nil # this has to return nil so that the driver or passenger knows how to deal with a no-trip entry
      elsif @start_time > @end_time
        raise ArgumentError.new("Invalid end time #{@end_time}")
      end
    end # initialize

    def <=>(other)
      if self < other
        -1
      elsif self > other
        1
      else
        0
      end
    end

    def trip_duration
      end_time_secs = (@end_time.hour * 3600) + (@end_time.min * 60)
      start_time_secs = (@start_time.hour * 3600) + (@start_time.min * 60)

      return end_time_secs - start_time_secs
    end

  end # trip
end
