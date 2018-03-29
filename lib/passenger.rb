require 'pry'

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

    # Any trip where the end time
    # is nil should NOT be included in your totals.
    def total_spent
      total = 0
      trips.each do |trip|
        if trip.cost != nil
          total += trip.cost
        end
        return total
      end
    end

    def total_duration
      total = 0
      trips.each do |trip|
        if trip.duration != nil
          total += trip.duration
        end
        return total
      end
    end
  end
end
