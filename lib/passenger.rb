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
      @trips << trip
    end

    def total_cost
      total_cost = 0
      @trips.each do |trip|
        total_cost += trip.cost
      end
      return total_cost
    end

    def total_time
      total_time = 0
      @trips.each do |trip|
        total_time += trip.duration
      end
      return total_time
    end

    def get_completed_trips
      completed_trips = @trips.select do |trip|
        trip.is_finished?
      end
      return completed_trips
    end
  end
end
