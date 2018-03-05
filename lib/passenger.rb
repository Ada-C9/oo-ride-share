# require_relative 'trip'

module RideShare
  class Passenger
    attr_reader :id, :name, :phone_number, :trips

    def initialize(input)
      @id = RideShare.return_valid_id_or_error(input[:id])
      @name = RideShare.return_valid_name_or_error(input[:name])
      @phone_number = input[:phone]
      @trips = RideShare.return_valid_trips_or_errors(input[:trips])
    end

    # Return all trip drivers.
    def get_drivers
      return @trips.map{ |trip| trip.driver }
    end

    # Throws ArgumentError if provided trip is not a valid Trip. Otherwise, adds
    # trip to trips.
    def add_trip(trip)
      @trips << RideShare.return_valid_trip_or_error(trip)
    end

    # Returns the
    def get_total_money_spent
      return @trips.inject(0.0) { |sum, trip| sum + trip.cost if
        !trip.is_in_progress? }
    end

    # Returns the sum of all complete trips durations in seconds.
    def get_total_time
      return RideShare.get_all_trip_durations_in_seconds(@trips)
    end

    private


  end
end
