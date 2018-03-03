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

     def get_total_spent
      @trips.map { |trip| trip.cost }.compact.sum
    end

    # # Alternative 1
    # def get_total_spent
    #   @trips.map { |trip| trip.cost != nil ? trip.cost : 0}.inject(0, :+)
    # end

    def get_drivers
      @trips.map { |trip| trip.driver }
    end

    def add_trip(trip)
      @trips << trip
    end

    def get_total_time
      Trip.total_time(@trips)
    end

    def accept_trip(trip)
      self.add_trip(trip)
    end

  end
end
