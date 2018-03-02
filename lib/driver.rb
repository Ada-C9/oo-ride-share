require 'csv'
require 'pry'
require_relative 'trip'

module RideShare
  class Driver # < Traveler
    attr_reader :id, :name, :vehicle_id, :status, :trips

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
      # @trips = input[:trips] || []
      # remove the above uncommented code and replace with below
      # if you create the Driver class as a subclass of Traveler
      #super (input[:trips])
    end

    # # this is a way to find all the passengers in the trips array
    # # EACH Style
    # def passengers
    #   passengers = []
    #   trips.each do |trip|
    #     passengers << trip.passenger
    #   end
    # end
    # return passengers.uniq
    #
    #
    # # MAP Style
    # passengers = trips.map do |trip|
    #   trip.passenger
    # end
    # return passengers.uniq


    def average_rating
      total_ratings = 0
      trips.each do |trip|
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
      unless trip.class <= Trip
        raise ArgumentError.new("Can only add trip instance to trip collection")
      end

      if trip.end_time == nil
        @status = :UNAVAILABLE
      end

      @trips << trip
    end

    def total_revenue
      fee = 1.65
      driver_takehome = 0.8

      subtotal = 0
      trips.each do |trip|
        # Question: what if the cost is less than the fee
        subtotal += trip.cost - fee
      end

      total = subtotal * driver_takehome
      return total
    end

    def average_revenue
      average = 0
      trips.each do |trip|
        average += (total_revenue / (trip.duration / 3600.0))
      end
      return average.round(2)
    end

  end # end of Driver class
end # end of RideShare module
