require 'csv'
require_relative 'trip'
require_relative 'trip_dispatcher'

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
    end # add_trip

    def total_revenue
      tax = 1.65
      driver_pay = 0.8
      gross_pay = 0

      trips.each do |trip|
        gross_pay += trip.cost - tax
      end
      total_revenue = gross_pay * driver_pay
      return total_revenue
    end

    # calulate drivers average revenue per hour spend driving
    def average_revenue
      # input: total_revenue, total_time_spent(hours),
      # output: average_revenue = total_revenue / total_time_spent
      average_revenue = 0
      total_time = Trip.total_time(trips)/60/60.round(2)
      average = self.total_revenue / total_time
      #12.04/.8
      average_revenue += average
      # ((Passenger.total_time_spent * 60)* 60)
      return average_revenue.round(2)
    end

    def find_available_drivers
      driver = @drivers.find{  |d| d.status == :AVAILABLE}
      return driver
    end # available_drivers

    def change_status
      
    end
  end # class
end # module
