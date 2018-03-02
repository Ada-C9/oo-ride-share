require_relative 'trip'
require_relative 'trip_dispatcher'


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
    end # add trip
    # return the total amount of money that passenger has spent on their trips
    def total_spent
      total_cost = 0
      trips.each do |trip|
        total_cost += trip.cost
      end
      return total_cost
    end # total_spent method

    # return the total amount of time that passenger has spent on their trips in seconds
    def total_time_spent
      # time_spent = 0
      time_spent = Trip.total_time(trips)
      # trip_duration = (@end_time - @start_time)
      # trips.each do |trip|
      #   time_spent += trip.duration
      # end
      return time_spent
    end # total_time_spent method
  end # class passenger
end # module
