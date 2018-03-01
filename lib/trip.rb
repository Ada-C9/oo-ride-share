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

      unless @end_time == nil || @start_time == nil
        if @end_time < @start_time #something is up with this
          raise ArgumentError.new("Trip End Time cannot be before Trip Start Time")
        end
      end

      unless @rating == nil
        if @rating > 5 || @rating < 1
          raise ArgumentError.new("Invalid rating #{@rating}")
        end
      end
    end

    def calculate_duration
      unless @end_time == nil || @start_time == nil
        return @end_time - @start_time
      end
    end

  end
end
#
# trip_start_time = Time.new(2017, 04, 05, 8, 0, 1, "-00:00")
# trip_end_time = Time.new(2017, 04, 05, 9, 0, 1, "-00:00")
# trip_input = {id: 1,driver: 12, passenger: 13, start_time: trip_start_time, end_time: trip_end_time, cost: 20.00, rating: 5}
# # trip_input = {id: 1,driver: 12, passenger: 13, start_time: "2017-04-05T08:01:00+00:00", end_time: "2017-04-05T09:01:00+00:00", cost: 20.00, rating: 5}
# my_trip = RideShare::Trip.new(trip_input)
# puts my_trip.calculate_duration
