require 'csv'
require 'time'

module RideShare
  class Trip
    attr_reader :id, :passenger, :driver, :start_time, :end_time, :cost, :rating

    def initialize(input)
      @id = input[:id]
      @driver = input[:driver]
      @passenger = input[:passenger]
      @start_time = input[:start_time] ||= Time.parse('2016-04-05T14:01:00+00:00')
      @end_time = input[:end_time]
      @cost = input[:cost]
      @rating = input[:rating]

      if @rating != nil && (@rating > 5 || @rating < 1 )
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

      if @end_time != nil && (@start_time > @end_time)
        raise ArgumentError.new("Invalid Trip Time")
      end

    end
    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end

    def length
      trip_length =  @end_time - @start_time
      #in seconds
      return  trip_length
    end
  end
end
