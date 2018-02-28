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

    # pseudocode calc revenue
    # def calc revenue
      # load all trips w/ @trips
      # iterate through @ trips and sum up @trip.cost
      # subtract fee of 1.65 * num trips, so @trip.length
      # current amount is now subtotal
      # multiply subtotal by 0.80
      # this is now total revenue
    # end

    # follow along with live-code pseudocode lesson
    # Pseudocode: Total Revenue for Driver

    # Output - Total revenue (float)
    # Input - none
    # Where does it live? Driver#total_revenue

    # def total_revenue
      # fee = 1.65
      # driver_percentage = 0.80
      # subtotal = 0
      # @trips.each do |trip|
      # => Question - what if the ride costs less than the fee ???
        # subtotal += trip.cost - fee
      # end
      # total = subtotal * driver_percentage
      # return total
    # end
  end
end
