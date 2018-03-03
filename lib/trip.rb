require 'csv'

module RideShare
  class Trip
    attr_reader :id, :passenger, :driver, :start_time, :end_time, :cost, :rating

    def initialize(input)
      @id = input[:id]
      @driver = input[:driver]
      @passenger = input[:passenger]
      @start_time = input[:start_time]
      @end_time = input[:end_time] == nil ? nil : input[:end_time]
      @cost = input[:cost] == nil ? 0 : input[:cost]
      @rating = input[:rating]

      if @end_time != nil && @rating != nil
        if @end_time < @start_time
          raise ArgumentError.new("Invalid date range")
        elsif @rating > 5 || @rating < 1
          raise ArgumentError.new("Invalid rating #{@rating}")
        else
          return
        end
      end

    end

      def duration
        duration = (end_time - start_time) * 60
        return duration
      end

      def inspect
        "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
      end


  end
end
