require 'csv'
require 'pry'

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

      unless @rating == nil
        if @rating > 5 || @rating < 1
          raise ArgumentError.new("Invalid rating #{@rating}")
        end
      end

      unless @end_time == nil || @start_time == nil
        if @end_time < @start_time
          raise ArgumentError.new("End time cannot be after begin time!")
        end#end if statement
      end#end unless
    end#end initialize method

    def calculate_duration()
      # unless @end_time == nil || @start_time == nil
        difference = @end_time - @start_time
        return difference.to_i
      # end
    end#end calculate_duration method
  end#end class Trip
end#end module RideShare
