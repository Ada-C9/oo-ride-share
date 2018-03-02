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
      unless trip.class <= Trip
        raise ArgumentError.new("Can only add trip instance to trip collection")
      end
      @trips << trip
    end

    def total_spent
      total = 0
      @trips.each do |trip|
        if trip.end_time == nil
          total += 0
        else
          total += trip.cost
        end
      end
      return total
    end

    def total_time_spent
      total_time = 0
      @trips.each do |trip|
        if trip.end_time == nil
          total_time += 0
        else
          total_time += trip.trip_duration
        end
      end
      return total_time
    end
  end
end
