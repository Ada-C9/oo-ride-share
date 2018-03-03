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

    def completed_trips
      @trips.find_all do |trip|
        trip.end_time != nil && trip.cost != nil && trip.rating != nil
      end
    end

    def get_drivers
      @trips.map{ |t| t.driver }
    end

    def add_trip(trip)
      @trips << trip
    end

    def total_money
      # total = @trips.inject {|sum, trip| sum + trip[@cost]} # why isn't this working!!!
      total = 0

      self.completed_trips.each do |trip|
        total += trip.cost
      end
      return total
    end

    def total_time
      total_time = 0

      @trips.each do |trip|
        total_time += trip.duration
      end
      return total_time
    end

  end
end
