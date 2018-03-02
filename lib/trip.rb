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

      # Group review with Charles added this below but he suggests instead we put it as a method down below all this
      # @duration = (@end_time - @start_time).to_i

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

      # Add a check in Trip#initialize that raises an ArgumentError if the end time is before the start time, and a corresponding test
      if @start_time > @end_time
        raise ArgumentError.new("The #{@end_time} is before the #{@start_time}")
      end
    end # ends initialize method

    # Charles suggested to add this - for first part of Wave 2
    def finish_trip!
      @end_time = Time.now
    end

    # Charles suggested to add this - for first part of Wave 2
    def finished?
      return end_time != nil
    end

    # Group review with Charles added this below - to replace the "@duration" instance variable
    def duration
      (@end_time - @start_time).to_i
    end

    # Add an instance method to the Trip class to calculate the duration of the trip in seconds, and a corresponding test
    # This was my 'duration' method idea
    # def duration
    #   (Time.parse(@end_time) - Time.parse(@start_time)).to_i
    # end # ends duration method

    # Dee/Charles suggested to add this via Slack post
    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end

  end # ends class Trip
end # ends module RideShare
