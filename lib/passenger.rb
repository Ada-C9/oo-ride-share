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
      @trips.map{|t| t.driver}
    end

    def add_trip(trip)
      @trips << trip
    end

    def total_amount_spent
      sum = 0
      @trips.each do |a_trip|
        sum+=a_trip.cost*((a_trip.end_time - a_trip.start_time)/60)
      end
      return sum
    end

    def total_amount_time
      sum = 0
      @trips.each do |a_trip|
        sum+=a_trip.trip_in_seconds.to_i
      end
      return sum/(60*60)
    end

  end
end
