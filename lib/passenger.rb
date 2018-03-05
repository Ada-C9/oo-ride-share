
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

    def money_spent
      total_passenger_cost = 0
      finish_trip.each do |trip|
        total_passenger_cost += trip.cost
      end
      return total_passenger_cost
    end

    def time_spent
      total_passenger_time = 0
      finish_trip.each do |trip|
        total_passenger_time += trip.duration
      end
      return total_passenger_time
    end

    def finish_trip
      trips.reject {|trip| trip.end_time == nil}
    end

  end # end of Passenger class
end # end of RideShare module
