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

    def calculate_total_revenue
      total_cost = 0
      @trips.each do |trip|
        total_cost += trip.cost
      end
      return Float(total_cost).round(2)
    end

    def calculate_total_time
      total_time_in_seconds = 0
      @trips.each do |trip|
        total_time_in_seconds += trip.calculate_duration
      end
      total_time_in_minutes = total_time_in_seconds / 60
      return total_time_in_minutes
    end

  end
end
