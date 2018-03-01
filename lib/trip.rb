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
      # Group review with Charles added this below but he suggests instead we put it as a method down below all this
      # @duration = (@end_time - @start_time).to_i

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

      # Add a check in Trip#initialize that raises an ArgumentError if the end time is before the start time, and a corresponding test
      if @start_time > @end_time
        raise ArgumentError.new("The #{@end_time} is before the #{@start_time}")
      end

      # Charles suggested to add this - for first part of Wave 2
      # def finish_trip!
      #   @end_time = Time.now
      # end

      # Charles suggested to add this - for first part of Wave 2
      # def finished?
      #   return end_time != nil
      # end

      # Group review with Charles added this below - to replace the "@duration" instance variable
      # def duration
      #   (@end_time - @start_time).to_i
      # end

    end
  end
end
