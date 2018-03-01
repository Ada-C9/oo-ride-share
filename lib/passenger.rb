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

    def total_trips_cost()
      total_cost = @trips.inject(0) do |total, trip|
        total + trip.cost
      end
      return total_cost
    end

    def total_ride_time()
      total_time = @trips.inject(0) do |total, trip|
         total + trip.calculate_duration
      end
      return total_time
    end

    def new_ride(trip)
      @trips << trip
    end

  end#end passenger class
end#end rideshare module
