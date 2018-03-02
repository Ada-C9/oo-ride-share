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

      if @end_time != nil && @start_time != nil && @end_time < @start_time
        raise ArgumentError.new("Invalid times.")
      end

      if @rating != nil && (@rating > 5 || @rating < 1)
        raise ArgumentError.new("Invalid rating #{@rating}")
      end
    end # initialize

    def duration
      return !@end_time ? 0 : @end_time - @start_time
    end # duration

    def finish
      @end_time = Time.now
      @driver.status_switch
    end # finish

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end # inspect

  end # Class Trip
end # Module RideShare
