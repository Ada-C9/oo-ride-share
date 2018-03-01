require 'awesome_print'

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
      spent = 0
      @trips.each do |trip|
        spent += trip.cost
      end
      return spent.round(2)
    end

    def total_ride_time
      car_time = 0
      @trips.each do |trip|
        car_time += (trip.duration/60).round(2) #in minutes
      end
      return car_time
    end
  end
end















#
