require 'csv'

module RideShare
  class Trip
    PENDING_TRIP = 0
    attr_reader :id, :passenger, :driver, :start_time, :end_time, :cost, :rating

    def initialize(input)
      @id = input[:id]
      @driver = input[:driver]
      @passenger = input[:passenger]
      @start_time = input[:start_time]
      @end_time = input[:end_time]
      @cost = input[:cost]
      @rating = input[:rating]

      if @start_time == nil || @end_time == nil
        raise ArgumentError.new('Nil value for time is not accepted, :PENDING symbol or a Time object must be entered.')
      end

      if @start_time.class != Time
        raise ArgumentError.new('Time must be a Time object.')
      end
      
      if @end_time != :PENDING && @start_time  > @end_time
        raise ArgumentError.new('Invalid time input, end time cannot be greater than start time and must be a Time object.')
      end

      if @rating != :PENDING && (@rating > 5 || @rating < 1)
        raise ArgumentError.new("Valid rating range is between 1-5.")
      end
    end

    def trip_in_seconds
      difference = 0
      if end_time == :PENDING
        difference =  PENDING_TRIP
      else
        difference = end_time - start_time
      end
      return difference

    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end

  end
end
