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
      @trips.map{ |trip| trip.driver }
    end

    def add_trip(trip)
      if trip.class != Trip
        raise ArgumentError.new("Can only add trip instance to trip collection")
      end

      @trips << trip
    end

    def total_cost
      completed_trips.map { |trip| trip.cost }.reduce(0.0,:+)
    end

    def total_time
      completed_trips.map { |trip| trip.duration }.reduce(0.0,:+)
    end

    def completed_trips
      @trips.select { |trip| trip.is_finished? }
    end
  end
end
