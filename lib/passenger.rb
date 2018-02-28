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
      # did whoever gave us this input hash
      # put any trips in it?
      # will get nil back if the key in question
      # doesn't exist
      @trips = input[:trips] == nil ? [] : input[:trips]
    end

    def money_spent
      total = 0.0
      @trips.each do |trip|
        total += trip.cost
      end
      return total
    end

    def time_spent
      time_spent = 0.0
      @trips.each do |trip|
        time_spent += trip.trip_duration
      end
      return time_spent
    end

    def get_drivers
      @trips.map{ |t| t.driver }
    end

    def add_trip(trip)
      @trips << trip
    end
  end
end
