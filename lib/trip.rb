
require 'csv'
require 'time'

module RideShare
  class Trip
    attr_reader :id, :passenger, :driver, :start_time, :end_time, :cost, :rating, :status_in_progress
    # could add status to whether a driver have completed his ride or still driving

    def initialize(input)
      @id = input[:id]
      @driver = input[:driver]
      @passenger = input[:passenger]
      @start_time = input[:start_time]
      @end_time = input[:end_time]
      @cost = input[:cost]
      @rating = input[:rating]
      @trip_in_progress = false


      if @end_time == nil || @cost == nil || @rating == nil
        @trip_in_progress = true
      end


      if !@trip_in_progress && (@rating > 5 || @rating < 1)
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

      if  !@trip_in_progress && @end_time < @start_time
        raise ArgumentError.new("Invalid time")
      end

    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end

    def duration

      return 0 if @end_time == nil
      return (@end_time - @start_time).to_i

    end


  end



end
