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
      @rating = input[:rating] == nil ? nil : check_rating(input[:rating])

      if @start_time == nil || @end_time == nil
         # this has to return nil so that the driver or passenger knows how to deal with a no-trip entry
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
