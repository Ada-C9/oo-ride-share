require 'csv'

module RideShare
  class Trip
    attr_reader :id, :passenger, :driver, :start_time, :end_time, :cost, :rating

    def initialize(input)
      # @trips = input[:trips] == nil ? [] : input[:trips]
      @id = input[:id]
      @driver = input[:driver]
      @passenger = input[:passenger]
      @start_time = input[:start_time]
      @end_time = input[:end_time] == nil ? Time.now : input[:end_time]
      @cost = input[:cost] == nil ? 0 : input[:cost]
      @rating = input[:rating] == nil ? 1 : input[:rating]

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

      if @start_time > @end_time
        raise ArgumentError.new("Invalid end_time #{@end_time}")
      end
    end

    def duration
      (@end_time - @start_time).to_i
    end

  end
end
