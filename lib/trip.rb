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
      @end_time = input[:end_time] || nil
      @cost = input[:cost] ||  nil
      @rating = input[:rating] || nil


      if  @rating && ( @rating > 5 || @rating < 1 )
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

      if @end_time && ( @end_time - @start_time < 0 )
        raise ArgumentError.new("Inaccurate trip start and end times. Start time must be before end time.")
      end

    end

    def trip_length
      if @end_time == nil
        return 0
      else
        @end_time - @start_time
      end
    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end
  end
end
