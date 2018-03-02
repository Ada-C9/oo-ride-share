require 'csv'
require "time"

module RideShare
  class Trip
    attr_reader :id, :passenger, :driver, :start_time, :end_time, :cost, :rating

    def initialize(input)
      @id = input[:id]
      @driver = input[:driver]
      @passenger = input[:passenger]
      @start_time = input[:start_time].class == Time ? input[:start_time] : Time.parse(input[:start_time]) # instance of Time
      @end_time = input[:end_time] == nil ? nil : input[:end_time] # instance of Time
      @cost = input[:cost] == nil ? nil : input[:cost]
      @rating = input[:rating] == nil ? nil : input[:rating]

      if !@rating.nil? && (@rating > 5 || @rating < 1)
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

      if !@end_time.nil? && @start_time > @end_time
        raise ArgumentError.new("Invalid time")
      end
    end

    def duration
      @end_time - @start_time
    end

    # def inspect
    #   "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    # end

  end
end
