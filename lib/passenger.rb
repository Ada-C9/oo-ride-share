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


    def amount_spent

      total_trips_cost = 0
      @trips.each do |ride|
        ride.cost
        total_trips_cost += ride.cost
      end
      return total_trips_cost.to_f
    end

    def total_time
      total_time_spent = 0
      @trips.each do |ride|
        total_time_spent += ride.duration
      end
      return total_time_spent
    end

  end
end
