require 'csv'
require_relative 'trip'

module RideShare
  class Driver
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
      fee = 1.65
      driver_takehome = 0.8

      subtotal = 0
      @trips.each do |trip|
        # What if trip cost is less than the fee?
        subtotal += trip.cost - fee
      end
      total = subtotal * driver_takehome
      return total
    end

    # # Test 1: two trips
    # trips = [
    #   RideShare::Trip.new({cost: 5, rating: 3}),
    #   RideShare::Trip.new({cost: 7, rating: 3}),
    #   RideShare::Trip.new({cost: 8, rating: 3})
    # ]
    #
    # driver_data = {
    #   id: 7,
    #   vin: 'a' * 17,
    #   name: 'test driver',
    #   trips: trips
    # }
    # driver = Driver.new(driver_data)
    # driver.total_revenue.must_equal 8
  end
end
