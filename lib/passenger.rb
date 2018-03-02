require 'time'
module RideShare
  class Passenger
    attr_reader :id, :name, :phone_number, :trips

    def initialize(input)
      if input[:id] == nil || input[:id] <= 0
        raise ArgumentError.new("ID cannot be blank or less than zero.(got #{input[:id]})")
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
      if trip.class != Trip
        raise ArgumentError.new("Can only add trip instance to trip collection")
      end

      @trips << trip
    end

    def calculate_total_money_spent
      if trips.last.cost == nil
        included_trips = trips[0..-2]
        total_amount = included_trips.reduce(0){ |sum, trip| sum + trip.cost}
      else
        total_amount = trips.reduce(0){ |sum, trip| sum + trip.cost}
      end

      return total_amount.round(2)
    end

    def calculate_total_trips_duration
      if trips.last.end_time == nil
        included_trips = trips[0..-2]
        return included_trips.reduce(0){ |total, trip| total + trip.duration}
      else
        return trips.reduce(0){ |total, trip| total + trip.duration}
      end
    end

  end
end
