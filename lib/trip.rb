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

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

      return true if @end_time == nil || @start_time == nil

      if @end_time < @start_time
        puts "inside initialize start #{@start_time} and end #{@end_time}"
        raise ArgumentError.new("Invalid start (#{@start_time}) or end time (#{@end_time})")
      end
    end # initialize

    def duration
      time_diff = (end_time - start_time).to_i
      return time_diff
    end

  end # class
end # module

# can eliminate status if using this below.
# def end_time
#   @end_time = Time.now
# end
# boolean is returned below
# def finished?
#   return end_time != nil
# end
