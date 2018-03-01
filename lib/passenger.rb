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


    def total_amount_spent
      total_amount = 0
      @trips.each do |rides|
          total_amount += rides.cost
        end
      return total_amount
    end

    def total_time_spent
      total_duration = 0
      @trips.each do |ride|
        total_duration += ride.duration
      # (ride.end_time - ride.start_time)
      end
      return total_duration
    end

  end
end


# Did whoever gave us this input hash put any trip in it?
# if input.keys.include? :trips
# @trips = input[:trips]
# else
# @trips = []
# end
