require 'csv'

module RideShare
  class Trip
    attr_reader :id, :passenger, :driver, :start_time, :end_time, :cost, :rating

    def initialize(input)
      @id = input[:id]
      @driver = input[:driver]
      @passenger = input[:passenger]
      @start_time = input[:start_time] ||= Time.parse('2016-06-02T21:28:00+00:00')
      @end_time = input[:end_time] ||= Time.parse('2016-06-02T22:05:00+00:00')
      @cost = input[:cost]
      @rating = input[:rating]

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

      unless @end_time >= @start_time
        raise ArgumentError.new("Invalid date")
      end
    end

    def trip_duration
      duration = @end_time - @start_time
    end
  end
end
