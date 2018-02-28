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
      #if trips is empty array return nil?
      @trips = input[:trips] == nil ? [] : input[:trips]
    end

    def get_drivers
      #for each in @trips, run driver method on it
      #where is this driver method?
      @trips.map{ |t| t.driver }
    end

    #add a trip to the trip instance variable
    def add_trip(trip)
      @trips << trip
    end

    #here
    def total_spent

      total = 0
      if @trips == []
        return 0
      else
        trips.each do |trip|
          total += trip.cost
        end
      end
      return total
    end

  end
end
