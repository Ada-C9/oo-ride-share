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
      #utc no offset?
      @end_time = input[:end_time]
      #utc no offset?
      @cost = input[:cost]
      #float
      @rating = input[:rating]
      #(1..5)

      if end_time < start_time
        raise ArgumentError.new("Trip End Time cannot be before Trip Start Time")
      end

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end
    end
  end
end

# trip_input = {id: 1,driver: 12, passenger: 13, start_time: "2017-04-05T14:01:00+00:00", end_time: "2016-04-05T14:01:00+00:00", cost: 20.00, rating: 5}
# my_trip = RideShare::Trip.new(trip_input)
# puts my_trip
