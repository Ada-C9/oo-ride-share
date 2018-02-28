require 'csv'

module RideShare
  class Trip
    attr_reader :id, :passenger, :driver, :start_time, :end_time, :cost, :rating

    def initialize(input)
      @id = input[:id]
      @driver = input[:driver]
      @passenger = input[:passenger]
      @start_time = (input[:start_time])
      @end_time = (input[:end_time])
      @cost = input[:cost]
      @rating = input[:rating]

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

      if @end_time.to_f < @start_time.to_f
        # p "+++++TEST+++"
        # p @start_time
        # p @end_time
        #
        # p @start_time.to_f
        # p @end_time.to_f

        raise ArgumentError.new("Start time must be before end time.")

      end
    end

    def duration
      @duration = @end_time - @start_time
      return @duration
    end

  end
end
