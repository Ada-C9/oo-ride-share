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

      # Did whoever gave us this input hash put any trip on it?
      # if input.keys.include? :trips
      #     @trips = input[:trips]
      #    else
      #     @trips = []
      #   end
      @trips = input[:trips] == nil ? [] : input[:trips]
    end

    def get_drivers
      @trips.map{ |t| t.driver }
    end

    def add_trip(trip)
      @trips << trip
    end

    def passenger_spents?
      spents_array = @trips.collect {|trip| trip.cost}
      amount_spent = spents_array.sum
      return amount_spent
    end

    def travel_time
      time_array = @trips.collect {|trip| trip.trip_duration}
      amount_time = time_array.sum
      return amount_time
    end
  end
end
