# require_relative 'trip'

module RideShare
  class Passenger
    attr_reader :id, :name, :phone_number, :trips

    def initialize(input)
      @id = valid_id_or_error(input[:id])
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

    def get_total_money_spent
      return @trips.inject(0.0) { |total, trip| total + trip.cost }
    end

    private

    def valid_id_or_error(input_id)
      if input_id == nil || input_id <= 0
        raise ArgumentError.new("ID cannot be blank or less than zero.")
      end
      return input_id
    end

  end
end
