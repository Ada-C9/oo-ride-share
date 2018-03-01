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
      # @duration = duration_of_ride

      if @rating != nil
        if @rating > 5 || @rating < 1
          raise ArgumentError.new("Invalid rating #{@rating}")
        end
      end

      if @end_time != nil
        raise ArgumentError.new("End time cannot be before the start time.") if @start_time > @end_time
      end
    end

    def duration_method

      if @end_time == nil
        return nil
      end

      return (@end_time.to_f - @start_time.to_f)

    end

  end
end
