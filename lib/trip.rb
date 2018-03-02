require 'csv'
require 'time'
require 'pry'

module RideShare
  class Trip
    attr_reader :id, :passenger, :driver, :start_time, :end_time, :cost, :rating, :duration_seconds

    def initialize(input)
      @id = input[:id]
      @driver = input[:driver]
      @passenger = input[:passenger]
      @start_time = input[:start_time]
      @end_time = input[:end_time]
      @cost = input[:cost]
      @rating = input[:rating]
      @duration_seconds = 0

      unless @rating == nil
        if @rating > 5 || @rating < 1
          raise ArgumentError.new("Invalid rating #{@rating}")
        end
      end

      unless @end_time == nil
        @duration_seconds = @end_time.to_i - @start_time.to_i
        if @duration_seconds < 0
          raise ArgumentError.new("End time (#{@end_time}) cannot be before start time (#{@start_time}).")
        end
      end
    end

    def report_trip_duration
      # Yeah, so when I started doing Wave I, I somehow
      #decided that trip duration needed some sort of
      #plain-English reporting method.  Turns out it doesn't,
      #but by the time I figured that out, I'd already gotten
      #this working, so what the hey, it's here now.
      trip_hrs_round = (@duration_seconds / 3600)
      trip_min_remdr_round = ((@duration_seconds % 3600) / 60)
      trip_sec_remdr = ((@duration_seconds % 3600) % 60)
      @duration_string = "#{trip_hrs_round} hour(s), #{trip_min_remdr_round} minute(s), #{trip_sec_remdr} second(s)."
    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end
  end
end
