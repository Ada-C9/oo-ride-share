require 'csv'
require 'time'
require "pry"

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

      if @end_time == nil
      elsif @start_time > @end_time
        raise ArgumentError.new("The #{@end_time} is before the #{@start_time}")
      end

    end # ends initialize method

    def finish_trip!
      if finished?
        raise "The trip is already finished!"
      end
      @end_time = Time.new
    end # ends "finish_trip!" method

    def finished?
      return end_time != nil
    end # ends "finished?" method

    def finished_trips
      trips.select {|trip| trip.end_time == nil}
    end

    def duration
      (@end_time - @start_time).to_i
    end # ends "duration" method

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end

  end # ends class Trip
end # ends module RideShare
