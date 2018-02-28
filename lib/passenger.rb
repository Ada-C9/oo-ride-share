
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

    def total_amount_of_money
      total = 0
      @trips.each do |trip|
        total += trip.cost
      end
      return total
    end

    def total_amount_of_time
      total_duration = 0
      @trips.each do |trip|
        total_duration += trip.trip_duration
      end
      return total_duration
    end

  end

end
