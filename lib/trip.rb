require 'csv'
require 'time'


module RideShare
  class Trip
    attr_reader :id, :passenger, :driver, :start_time, :end_time, :cost, :rating

    def initialize(input)
      @id = input[:id]
      @driver = input[:driver]
      @passenger = input[:passenger]
      @start_time = input[:start_time].class == Time ? input[:start_time] : 0
      @end_time = input[:end_time].class == Time ? input[:end_time] : 1
      @cost = input[:cost]
      @rating = input[:rating]

      if @end_time <= @start_time
        raise ArgumentError.new("Invalid times: #{@end_time} occurs before #{@start_time}")
      end

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end
    end

    def calculate_duration
      @end_time - @start_time
    end
  end
end
