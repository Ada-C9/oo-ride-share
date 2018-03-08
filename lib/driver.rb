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

    def set_status(new_trip)
      @trips << new_trip
      @status = :UNAVAILABLE

    end

    def total_revenue
      if !@trip_in_progress
        if @trips.length == 0
          return 0
        else

          fee = 1.65
          driver_portion = 0.8
          subtotal = @trips.map {|trip| trip.cost - fee}.inject(0, :+) * driver_portion
        end
        return subtotal.round(2)

      end

    end


    def average_revenue
      if !@trip_in_progress
        total_revenue
        if @trips.length == 0
          return 0
        else
          total_time = 0
          @trips.each do |trip|
            total_time += trip.end_time - trip.start_time

          end
          total_time_per_hour = total_time/3600
          avg_revenue = (total_revenue) /(total_time_per_hour)
        end
        return avg_revenue.round(2)
      end
    end

  end
end
