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
        raise ArgumentError.new('nil value for time is not accepted.')
      end

      if @start_time.class != Time
        raise ArgumentError.new('Time must a Time class object')
      end

      if @end_time != :PENDING && @start_time  > @end_time
        raise ArgumentError.new('invalid time input')
      end

      if @rating != :PENDING && (@rating > 5 || @rating < 1)
        raise ArgumentError.new("Invalid rating #{@rating}")
      end
    end

    def trip_in_seconds
      if end_time == :PENDING
        difference =  PENDING_TRIP
      end
      #passing with integers.
      return   end_time - start_time

    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end

  end
end
