# require_relative 'trip'

module RideShare
  class Passenger
    attr_reader :id, :name, :phone_number, :trips

    def initialize(input)
      @id = RideShare.return_valid_id_or_error(input[:id])
      @name = RideShare.return_valid_name_or_error(input[:name])
      @phone_number = return_valid_phone_or_error(input[:phone])
      @trips = RideShare.return_valid_trips_or_errors(input[:trips])
    end

    # Return all trip drivers.
    def get_drivers
      return return_all_drivers
    end

    # Throws ArgumentError if provided trip is not a valid Trip. Otherwise, adds
    # trip to trips.
    def add_trip(trip)
      add_trip_if_valid(trip)
    end

    # Returns the
    def get_total_money_spent
      return calculate_total_money_spent
    end

    # Returns the sum of all complete trips durations in seconds.
    def get_total_time
      return RideShare.get_all_trip_durations_in_seconds(@trips)
    end

    private

    def add_trip_if_valid(trip)
      @trips << RideShare.return_valid_trip_or_error(trip)
    end

    def calculate_total_money_spent
      return @trips.inject(0.0) { |sum, trip|
        trip.is_in_progress? ? sum + 0 : sum + trip.cost }
    end

    def return_all_drivers
      return @trips.map{ |trip| trip.driver }
    end

    def return_valid_phone_or_error(input_phone_num)
      if input_phone_num.class != String || input_phone_num.count("0-9") < 10
        raise ArgumentError.new("Invalid phone number #{input_phone_num}")
      end
      return input_phone_num
    end


  end
end
