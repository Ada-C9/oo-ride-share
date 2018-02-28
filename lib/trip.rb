require 'csv'

module RideShare
  class Trip
    attr_reader :id, :passenger, :driver, :start_time, :end_time, :cost, :rating

    def initialize(input)
      @id = input[:id]
      @driver = input[:driver]
      @passenger = input[:passenger]
      @start_time = check_start_time(input[:start_time])
      @end_time = check_end_time(input[:end_time])
      @cost = input[:cost]
      @rating = input[:rating]

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

      check_time

    end

    def duration
      @duration = @end_time - @start_time
      return @duration
      # return 1500.0
    end

    # private

    def check_time
      # if @end_time == @start_time
      #   raise ArgumentError.new("Start time must be before end time.")
      # end

      if (@end_time != nil && @start_time != nil) && (@end_time != @start_time)
        # Checking end time is not equal to start time or it is smaller than start time
        if @end_time < @start_time
          raise ArgumentError.new("Start time must be before end time.")
        end
      end
    end

    def check_start_time(start_time_input)
      if start_time_input.class == String
        @start_time = Time.parse(start_time_input)
      else
        @start_time = start_time_input
      end
      return @start_time
    end

    def check_end_time(end_time_input)
      if end_time_input.class == String
        @end_time = Time.parse(end_time_input)
      else
        @end_time = end_time_input
      end
      return @end_time
    end
  end
end
