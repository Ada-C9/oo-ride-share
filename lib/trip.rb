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

      # TODO: update in-progress trip labeling
      if @end_time == nil || @cost == nil || @rating == nil
        puts "This is a in-progress trip."
        return
      end

      if @end_time < @start_time
        raise ArgumentError.new("Invalid time")
      end

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

    end
    def duration
      (@end_time - @start_time).to_i
    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end

  end
end
