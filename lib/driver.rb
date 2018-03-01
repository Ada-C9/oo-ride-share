require 'csv'
require_relative 'trip'

module RideShare
  class Driver
    attr_reader :id, :name, :vehicle_id
    attr_accessor :status, :trips

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
    end

    def add_trip(trip)
      if trip.class != Trip
        raise ArgumentError.new("Can only add trip instance to trip collection")
      end

      @trips << trip
    end

    def total_revenue
      # with each loop:
      # total_rev = 0
      # @trips.each do |trip|
      #   fee = 1.65
      #   trip_rev = (trip.cost - fee) * 0.8
      #   total_rev += trip_rev
      # end
      #return total_rev

      # with map:
      # trip_rev = @trips.map {|trip| (trip.cost - 1.65) * 0.8}
      # total_rev = trip_rev.sum

       total_rev = @trips.inject(0) {| sum , trip| sum + ((trip.cost - 1.65) * 0.8)}
       return total_rev
    end

    def average_revenue
      ave_rev = total_revenue / @trips.length
      #return ave_rev
    end

    def change_to_unavailable
      @status = :UNAVAILABLE
    end

  end
end
