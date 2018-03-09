require_relative 'trip'

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

    def total_spend
      finished_trips = @trips.select{ |trip| trip.end_time != nil}
      puts "finished_trips: #{finished_trips}"
      total = 0

      finished_trips.each do |trip|
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
