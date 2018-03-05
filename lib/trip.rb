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
      @end_time = input[:end_time]
      @cost = input[:cost]
      @rating = input[:rating]

      # conditional that allows trip initialize to ignore in-progress trips
      if @end_time != nil || @end_time == @start_time
        if @end_time < @start_time
          raise ArgumentError.new("Invalid times: #{@end_time} occurs before #{@start_time}")
        end
        if @rating > 5 || @rating < 1
          raise ArgumentError.new("Invalid rating #{@rating}")
        end
      end
    end

    def calculate_duration
      @end_time - @start_time
    end

    def inspect
      "#<#{self.class.name}: 0x#{self.object_id.to_s(16)}>"
    end
  end
end
