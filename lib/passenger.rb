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
      total_spent = 0
      @trips.each { |trip| total_spent += trip.cost }
      return total_spent
    end

    def time_spent
      time_spent = 0
      @trips.each { |trip| time_spent += trip.duration }
      return time_spent
    end
  end
end
