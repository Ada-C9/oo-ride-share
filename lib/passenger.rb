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

    def calculate_all_trips_cost
      total_cost = 0
      @trips.each do |trip|
        if trip.cost != nil
          total_cost += trip.cost
        end
      end
      return total_cost.to_f.round(2)
    end

    def calculate_total_trips_time_in_sec
      trip_time_lengths = []
      @trips.each do |trip|
        if trip.end_time != nil
          trip_duration = trip.end_time.to_f - trip.start_time.to_f
          trip_time_lengths << trip_duration
        end
      end
      total_time_in_sec = 0
      total_time_in_sec = trip_time_lengths.inject(:+)
      return total_time_in_sec
    end

  end # end of Passenger
end # end of RideShare
