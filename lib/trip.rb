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

      unless @rating == nil
        if @rating > 5 || @rating < 1
          raise ArgumentError.new("Invalid rating #{@rating}")
        end
      end

      unless @end_time == nil
        if @end_time.to_f < @start_time.to_f
          raise ArgumentError.new("The end of the ride cannot be before the beginning of the ride. Start time given as #{start_time} and end time given as #{end_time}.")
        end
      end
    end # end of initialize

    def inspect
      "#<#{self.class.name}: 0x#{self.object_id.to_s(16)}>"
    end
  end # end of Trip
end # end of RideShare
