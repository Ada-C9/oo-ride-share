require 'csv'
require 'time'

module RideShare
  class Trip
    attr_reader :id, :passenger, :driver, :start_time, :end_time, :cost, :rating

    def initialize(input)
      @id = input[:id]
      @driver = input[:driver]
      @passenger = input[:passenger]
      @start_time = Time.parse(input[:start_time])
      @end_time = Time.parse(input[:end_time])
      @cost = input[:cost]
      @rating = input[:rating]

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

      # if (@end_time - @start_time) <= 0
      #   raise ArgumentError.new("Trips must start in the past and be of a duration of at least 1 second.")
      # end
    end

  end
end
