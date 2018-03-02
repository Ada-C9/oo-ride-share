require 'time'
require 'pry'

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

    def log_newly_requested_trip(trip)
       @trips << trip
    end

    def total_ride_time
      #NOTA BENE: THIS METHOD NEEDS TO NOT SHIT THE BED IF THERE'S
      #A TRIP WITH A ZERO DURATION.
      @trips.map{ |t| t.duration_seconds }.reduce(:+)
    end

    def total_spent
      #NOTA BENE: THIS METHOD NEEDS TO NOT SHIT THE BED IF THERE'S
      #A TRIP WITH A NIL COST.
     @trips.map{ |t| t.cost }.reduce(:+)
    end
  end
end
