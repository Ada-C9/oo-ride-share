module RideShare
  class Passenger
    attr_reader :id, :name, :phone_number, :trips

    def initialize(input)
      if input[:id] == nil || input[:id] <= 0
        raise ArgumentError.new("ID cannot be blank or less than zero.")
      end

      @id = input[:id]
      #appear to be sequential up to 300
      @name = input[:name]
      #some names have middle names, prefixes, suffixes, apostrophes ("O'keefe")
      @phone_number = input[:phone]
      #phone numbers in csv are all types of formatting -- needs cleaning
      @trips = input[:trips] == nil ? [] : input[:trips]
      # trips will start out with an empty array otherwise whatever they gave us in the load_trips method
    end

    def get_drivers
      @trips.map{ |t| t.driver }
    end

    def add_trip(trip)
      @trips << trip
    end

    def total_spend
      total = 0
      @trips.each do |trip|
        total += trip.cost
      end
      return total
    end

    def total_ride_time_minutes
      total_ride_time_seconds = 0
      @trips.each do |trip|
        total_ride_time_seconds += trip.calculate_duration
      end
      total_ride_time_minutes = total_ride_time_seconds / 60
      return total_ride_time_minutes
    end
  end
end
