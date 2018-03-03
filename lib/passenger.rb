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
      # @trips needs to be an array
    end

    def get_drivers
      @trips.map{ |t| t.driver }
    end

    def add_trip(trip)
      @trips << trip
    end

    def in_progress
      return @trips.reject { |ride| ride.end_time == nil }
    end


    def total_money_spent
      total_amount = 0
      in_progress.each do |rides|
          total_amount += rides.cost
        end
      return total_amount
    end

    def total_duration
      total_time = 0
      in_progress.each do |ride|
        total_time += ride.duration
      # (ride.end_time - ride.start_time)
      end
      return total_time
    end

  end
end
