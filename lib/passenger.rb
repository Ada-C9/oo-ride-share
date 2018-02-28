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

    def get_total
      @trips.map { |trip| trip.cost }.inject(0, :+)
    end

    def get_drivers
      @trips.map { |t| t.driver }
    end

    def add_trip(trip)
      @trips << trip
    end

    def get_trip_time
      trip_time = 0
      @trips.each do |trip|
        unless trip.get_duration.nil?
          trip_time += trip.get_duration
        end
      end
      return trip_time

      # # Alternative 1
      # def get_trip_time
      #   @trips.map {|trip| trip.get_duration !=nil ? trip.get_duration : 0}.inject(0, :+)
      # end

    end

  end
end
