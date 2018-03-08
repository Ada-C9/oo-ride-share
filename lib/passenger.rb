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
      trips.map{ |t| t.driver }
    end

    def add_trip(trip)
      trips << trip
    end

    def completed_trips
      trips.select {|trip| trip.end_time != nil}
    end

    def total_spent
      total_spent = completed_trips.inject(0) { |sum, trip| sum + trip.cost }
    end


    def total_time
      completed_trips.inject(0) {|sum, trip| sum + trip.duration}
    end


  end
end
