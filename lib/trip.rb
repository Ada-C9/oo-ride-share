require 'csv'
require "time"
#require_relative "trip"
#require_relative "trip_dispatcher"

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

      unless @start_time == nil || @end_time == nil
        if @start_time > @end_time
          raise ArgumentError.new("This trip is not rigth, starting time should be before end time")
        end
      end

      unless @rating == nil
        if @rating > 5 || @rating < 1
          raise ArgumentError.new("Invalid rating #{@rating}")
        end
      end
    end

    def in_progress?
      if end_time == nil
        return true
      end
    end



    def trip_duration
      if @start_time == nil || @end_time == nil
        raise ArgumentError.new("can´t calculate trip_duration when end or start time are not given")
      end
      duration = @end_time - @start_time
      return duration
    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end

  end
end
