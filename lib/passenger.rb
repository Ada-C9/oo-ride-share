# require_relative 'trip'

module RideShare
  class Passenger
    attr_reader :id, :name, :phone_number, :trips

    def initialize(input)
      @id = RideShare.return_valid_id_or_error(input[:id])
      @name = RideShare.return_valid_name_or_error(input[:name])
      @phone_number = input[:phone]
      @trips = input[:trips] == nil ? [] : RideShare.valid_trips_or_errors(input[:trips])
    end

    def get_drivers
      @trips.map{ |trip| trip.driver }
    end

    def add_trip(trip)
      @trips << RideShare.return_valid_trip_or_error(trip)
    end

    def get_total_money_spent
      return @trips.inject(0.0) { |total, trip| total + trip.cost }
    end

    def get_total_time
      return @trips.inject(0) { |total, trip| total + trip.get_duration }
    end

    private


  end
end
