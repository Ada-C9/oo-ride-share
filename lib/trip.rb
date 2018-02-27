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
      end

      if @start_time == nil || @end_time == nil
        return nil
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

  end # trip
end
