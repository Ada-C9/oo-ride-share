module RideShare
  class Passenger
    attr_reader :id, :name, :phone_number, :trips

    def initialize(input)
      if input[:id] == nil || input[:id] <= 0
        raise ArgumentError.new("ID cannot be blank or less than zero.")
      end

      @id = input[:id]
      @name = input[:name]
      @phone_number = input[:phone_number]
      @trips = input[:trips] == nil ? [] : input[:trips]
    end

    def get_drivers
      @trips.map{ |t| t.driver }
    end

    def add_trip(trip)
      @trips << trip
    end

    def total_cost
      total_cost = 0
      @trips.each do |trip|
        if !trip.ignore
          total_cost += trip.cost
        end
      end
      return total_cost
    end

    def total_time
      @trips.reduce(0) { |total, trip| total + trip.duration }
    end

  end
end
