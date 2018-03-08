module RideShare
  class Passenger
    attr_reader :id, :name, :phone_number, :trips

    def initialize(input)
      raise ArgumentError.new("ID cannot be blank or less than zero.") if input[:id] == nil || input[:id] <= 0

      @id = input[:id]
      @name = input[:name]
      @phone_number = input[:phone]
      @trips = input[:trips] == nil ? [] : input[:trips]
    end

    def get_drivers
      @trips.map{ |t| t.driver }
    end

    def add_trip(trip)
      # Add trip to passangers list:
      raise ArgumentError.new("Can only add trip instance to trip collection") if trip.class != Trip
      @trips << trip
    end

    def total_spent
      # Passanger's total $ spent so far:
      total_money = 0
      @trips.each {|trip| trip.end_time == nil ? total_money += 0 : total_money += trip.cost}
      return total_money
    end

    def total_time_spent
      # Passanger's total time spent so far:
      total_time = 0
      @trips.each {|trip| trip.end_time == nil ? total_time += 0 : total_time += trip.trip_duration}
      return total_time
    end
  end
end
