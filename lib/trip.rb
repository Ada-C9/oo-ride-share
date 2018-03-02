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

      if @rating != nil && (@rating > 5 || @rating < 1)
        raise ArgumentError.new("Invalid rating #{@rating}")
      end


      if @end_time != nil && (@start_time > @end_time)
        raise ArgumentError.new("Invalid end time #{@end_time}")
      end

    end

    # anytime we care to know status we can call method
    # def finish_trip!
    #   end_time = Time.now
    # end
    #
    # def finished?
    #   return @end_time != nil
    # end

    def duration
      return (end_time - start_time).to_i
    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end

  end
end
