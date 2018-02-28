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

    def total_spent
      cost = 0.00
      @trips.each do |trip|
        cost += trip.cost
      end
      return cost.round(2)
    end

    def total_time
      total = 0
      @trips.each do |trip|
        total += trip.trip_duration
      end
      return total
      # hours = total / 3600
      # minutes = (total % 3600) / 60
      # seconds = (total % 3600) % 60
      # return "You've ridden for a total of #{hours} hours, #{minutes} minutes, and #{seconds} seconds."
    end

  end # Passenger
end # RideShare
