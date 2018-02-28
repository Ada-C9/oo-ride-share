require 'csv'

module RideShare
  class Trip
    attr_reader :id, :passenger, :driver, :start_time, :end_time, :duration, :cost, :rating

    def initialize(input)
      @id = input[:id]
      @driver = input[:driver]
      @passenger = input[:passenger]

      @start_time = input[:start_time]
      @end_time = input[:end_time]

      unless @start_time.nil? || @end_time.nil?
        if @start_time > @end_time
          raise ArgumentError.new("#{@end_time} is before #{@start_time}")
        end
      end

      @duration = nil
      if !@start_time.nil? && !@end_time.nil?
        @duration = @end_time - @start_time
      end

      @cost = input[:cost]
      @rating = input[:rating]

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end
    end
  end
end
