require 'csv'
require 'time'

module RideShare
  class Trip
    attr_reader :id, :passenger, :driver, :start_time, :end_time, :cost, :rating

    def initialize(input)
      @id = input[:id]
      @driver = input[:driver]
      @passenger = input[:passenger]
      @start_time = input[:start_time].nil? ? nil : Time.parse(input[:start_time])
      @end_time = input[:end_time].nil? ? nil : Time.parse(input[:end_time])
      @cost = input[:cost]
      @rating = input[:rating] == nil ? nil : check_rating(input[:rating])

      if !(@start_time == nil || @end_time == nil) && @start_time.to_i > @end_time.to_i
        raise ArgumentError.new("Invalid end time #{@end_time}")
      end
    end # initialize

    def trip_duration
      return @end_time.to_i - @start_time.to_i
    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end

    private

    def check_rating(rating)
      if (rating > 5 || rating < 1)
        raise ArgumentError.new("Invalid rating #{rating}")
      end
      return rating
    end

  end # trip
end
