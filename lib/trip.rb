require 'csv'

module RideShare
  class Trip
    PENDING_TRIP = 0
    attr_reader :id, :passenger, :driver, :start_time, :end_time, :cost, :rating

    def initialize(input)
      @id = input[:id]
      @driver = input[:driver]
      @passenger = input[:passenger]
      @start_time = input[:start_time]
      @end_time = input[:end_time]
      @cost = input[:cost]
      @rating = input[:rating]
      #@start_time.class != Symbol && @end_time.class != Symbol
      if @start_time != :PENDING && @end_time != :PENDING && @start_time  > @end_time
        raise ArgumentError.new('invald time input')
      end

      if @rating != :PENDING && (@rating > 5 || @rating < 1)
        raise ArgumentError.new("Invalid rating #{@rating}")
      end
    end

    def trip_in_seconds
      if end_time == :PENDING && start_time = :PENDING
        return PENDING_TRIP
      else
      return (end_time.to_i - start_time.to_i)
    end
    end

  end
end
