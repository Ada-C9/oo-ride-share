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

      if @rating != nil
        raise ArgumentError.new("Invalid rating #{@rating}")  if @rating > 5 || @rating < 1
      end

      raise ArgumentError.new("End time cannot be before the start time.") if @start_time > @end_time if @end_time != nil
    end

    def trip_duration
      return @end_time == nil ? nil : (@end_time.to_f - @start_time.to_f)
    end

    def inspect
      # Fix testing bug:
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end
  end
end
