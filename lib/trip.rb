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

      if @rating != nil
        if @rating > 5 || @rating < 1
          raise ArgumentError.new("Invalid rating #{@rating}")
        end
      end


      if @end_time != nil
        if @start_time > @end_time
          raise ArgumentError.new("Invalid time")
        end
      end
    end

    def duration
      duration = (@end_time - @start_time)
      return duration
    end

    def finish_trip!
      @end_time = Time.new
    end

    def finished?
      return end_time != nil
    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end
  end
end
