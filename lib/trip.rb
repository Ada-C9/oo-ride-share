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

      unless @rating.nil?
        if @rating > 5 || @rating < 1
          raise ArgumentError.new("Invalid rating #{@rating}")
        end
      end

      unless @end_time.nil?
        if (@start_time <=> @end_time) == 1
          raise ArgumentError.new("Invalid time entries. Trip end time must be later than start time.")
        end
      end
    end

    def duration
      @end_time - @start_time
    end

    def is_finished?
      @end_time != nil
    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end
  end
end
