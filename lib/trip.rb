require 'csv'

module RideShare
  class Trip
    attr_reader :id, :passenger, :driver, :start_time, :end_time, :cost, :rating, :duration

    def initialize(input)
      @id = input[:id]
      @driver = input[:driver]
      @passenger = input[:passenger]
      @start_time = input[:start_time]
      @end_time = input[:end_time]
      @cost = input[:cost]
      @rating = input[:rating]
      @duration = input [:duration]

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

      if @start_time.to_i > @end_time.to_i
        raise ArgumentError.new("Start time must be before end time.")
      end
    end

    def duration
      @duration = (@end_time.to_i - @start_time.to_i)
      return @duration
    end



  end
end
