require 'csv'
# require 'pry'

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

      if end_time == nil && cost == nil && rating == nil
        
      end

      if start_time > end_time
        raise ArgumentError.new("End time #{@end_time} cannot be before start time#{@start_time}.")
      end

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end
    end


    def duration
      trip_duration = (@end_time - @start_time) * 60
      return trip_duration
    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end


  end

end
