require_relative "trip"

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

    def total_money_spent
      money = 0
      @trips.each do |trip|
        unless trip.in_progress? == true
          money += trip.cost
        end
      end
      return money
    end

    def total_time_spent
      time = 0
      @trips.each do |thistrip|
        unless thistrip.in_progress? == true
          time += thistrip.trip_duration
        end
      end
      return time
    end
  end
end

# trips = [
#   RideShare::Trip.new({start_time: "2016-04-05 14:01:00 +0000", end_time: "2016-04-05 14:02:00 +0000", id: 3}),
#   RideShare::Trip.new({start_time: "2016-04-05 13:01:00 +0000", end_time: "2016-04-05 14:02:00 +0000", id: 3})
# ]
# total = RideShare::Passenger.new(id: 4, trips: trips)
# puts total.total_time_spent
