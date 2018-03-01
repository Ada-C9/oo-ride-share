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
        # unless trip.class <= Trip
        #tripclass is subclass or instance of Trip
        raise ArgumentError.new("Can only add trip instance to trip collection")
      end

      @trips << trip
    end

    def total_revenue
      #revenue = RideShare::Passenger.ne.total_amount_of_money
      if @end_time != nil
      total = 0.0
      @trips.each do |trip|
        total+= trip.cost
      end
      total_revenue = total * 0.8 - 1.65
      return total_revenue.round(2)
    end
    end

    def average_revenue
      total_revenue
      total_time = 0
      @trips.each do |trip|
        total_time += (trip.end_time) - (trip.start_time)

      end
      total_time_per_hour = total_time/3600
      avg_revenue = (total_revenue) /(total_time_per_hour)
      return avg_revenue.round(2)
    end

    # def passengers
    #   passangers = []
    #   trips.each do |trip|
    #     passengers << trip.passanger
    #   end
    #   return passengers.uniq
    # using map
    # passengers = trips.map do |trip|
    #   trip.passenger
    # end
  end
end
