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

      # **W1:RAISES ERROR ON INITIALIZATION FOR END TIME BEFORE START TIME------
      if @end_time < @start_time
        raise ArgumentError.new("end time cannot be before the start time. (got #{[@end_time]})")
      end
      # **W1:RAISES ERROR ON INITIALIZATION FOR END TIME BEFORE START TIME------
      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end
    end
    # **W1:MAKE INSTANCE METHOD TO CALCULATE DURATION OF TRIP IN SECONDS----------
    # def duration
    #
    # end
    # **W1:MAKE INSTANCE METHOD TO CALCULATE DURATION OF TRIP IN SECONDS----------
  end
end
