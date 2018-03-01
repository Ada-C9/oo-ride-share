require 'time'
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

    def calculate_total_money_spent
      total_amount = @trips.reduce(0){ |sum, trip| sum + trip.cost}
      return total_amount.round(2)
    end

    def calculate_total_trips_duration
      total_duration = @trips.reduce(0){ |total, trip| total + trip.duration}
      return total_duration
    end
  end
end

#
# passenger = dispatcher.load_passengers[0]
# passenger.trips

# puts dispatcher.calculate_total_money_spent
