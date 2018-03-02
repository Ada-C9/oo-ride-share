module RideShare
  class Passenger
    attr_reader :id, :name, :phone_number
    attr_accessor :trips

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
      total = 0
      @trips.each do |i|
        if i.end_time == nil
          total += 0
        elsif
          total += i.cost
        end
      end
      return total.round(2)
    end

    def total_time
      total = 0
      @trips.each do |i|
        total += (i.trip_length)
      end
      return total
    end

    def in_progress(new_trip)
      add_trip(new_trip)
    end
  end
end
