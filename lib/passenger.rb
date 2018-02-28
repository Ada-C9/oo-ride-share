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

    def total_spending
      @trips.map{|trip| trip.cost}.inject(0, :+).round(2)
    end

    def total_time
      @trips.map{|trip| (trip.end_time - trip.start_time)}.inject(0, :+).round(1)
    end

  end # Passenger class ends

end # Rideshare module ends
