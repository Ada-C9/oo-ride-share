require 'csv'
require_relative 'trip'

module RideShare
  class Driver
    attr_reader :id, :name, :vehicle_id, :status, :trips

    FEE_PER_TRIP = 1.65
    REV_PERCENT = 0.80

    def initialize(input)
      if input[:id] == nil || input[:id] <= 0
        raise ArgumentError.new("ID cannot be blank or less than zero. (got #{input[:id]})")
      end
      if input[:vin] == nil || input[:vin].length != 17
        raise ArgumentError.new("VIN cannot be less than 17 characters.  (got #{input[:vin]})")
      end

      @id = input[:id]
      @name = input[:name]
      @vehicle_id = input[:vin]
      @status = input[:status] == nil ? :AVAILABLE : input[:status]

      @trips = input[:trips] == nil ? [] : input[:trips]
    end

    def average_rating
      total_ratings = 0
      @trips.each do |trip|
        total_ratings += trip.rating
      end

      if trips.length == 0
        average = 0
      else
        average = (total_ratings.to_f) / trips.length
      end

      return average
    end # average_rating

    def add_trip(trip)
      if trip.class != Trip
        raise ArgumentError.new("Can only add trip instance to trip collection")
      end

      @trips << trip
    end # add_trip

    def total_revenue

      if @trips == []
        return 0
      else
        costs = @trips.map do |trip|
          if trip.cost < FEE_PER_TRIP
            0
          else
            trip.cost-FEE_PER_TRIP
          end
        end

        subtotal = costs.inject(:+)
        total_revenue = REV_PERCENT*subtotal

        return total_revenue
      end

    end # total_revenue

    def ave_revenue_per_hour
      rev = self.total_revenue
      seconds = @trips.map {|trip| trip.duration}.sum
      hours = (seconds/60)/60
      return 0 if hours == 0
      average = rev/hours
      return average.round(2)
    end

    def status_switch
      if @status == :AVAILABLE
        @status = :UNAVAILABLE
      else
        @status = :AVAILABLE
      end
    end

    def turn_off  # FOR TESTING PURPOSES ONLY
      @status = :UNAVAILABLE
    end


  end # Class Driver
end # Module RideShare
