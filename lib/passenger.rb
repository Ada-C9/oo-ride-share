require_relative 'trip'

module RideShare
  class Passenger
    attr_reader :id, :name, :phone_number, :trips

    def initialize(input)
      if input[:id] == nil || input[:id] <= 0
        raise ArgumentError.new("ID cannot be blank or less than zero.")
      end

      @id = input[:id]
      @name = input[:name]
      @phone_number = input[:phone]
      @trips = input[:trips] == nil ? [] : input[:trips]

    end

    def get_drivers
      @trips.map{ |t| t.driver }
    end

    def add_trip(trip)
      @trips << trip
    end

    def trip_in_progress(trip) #why not just use existing add_trip(trip) here?
      @trips << trip
    end

    def total_spend
      finished_trips = @trips.select{ |trip| trip.end_time != nil}
      puts "finished_trips: #{finished_trips}"
      total = 0
      # @trips.each do |trip|
      finished_trips.each do |trip|
        total += trip.cost
      end
      return total
    end

    def total_ride_time_minutes
      total_ride_time_seconds = 0
      @trips.each do |trip|
        total_ride_time_seconds += trip.calculate_duration
      end
      total_ride_time_minutes = total_ride_time_seconds / 60
      return total_ride_time_minutes
    end
  end
end

#
# start_time = Time.parse('2015-05-20T12:14:00+00:00')
# end_time = start_time + 25 * 60 # 25 minutes
# trips = [
#   RideShare::Trip.new({cost: 10.00, rating: 3, start_time: start_time, end_time: end_time}),
#   RideShare::Trip.new({cost: 10.00, rating: 3, start_time: start_time, end_time: end_time}),
#   RideShare::Trip.new({cost: 10.00, rating: 3, start_time: start_time, end_time: end_time})
# ]
# passenger_data = {
#   id: 7,
#   name: 'Speed Passenger',
#   phone_number: '555.555.5555',
#   trips: trips
# }
# my_passenger = RideShare::Passenger.new(passenger_data)
# puts my_passenger.trips
# puts my_passenger.total_spend
