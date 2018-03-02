require 'csv'
require 'time'
require 'pry'
require_relative 'trip'

module RideShare
  class Driver
    attr_reader :id, :name, :vehicle_id, :total_revenue, :average_revenue
    attr_accessor :trips, :status

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
      trips_in_progress = 0
      @trips.each do |trip|
        if trip.rating != nil
          total_ratings += trip.rating
        else trips_in_progress += 1
        end
      end

      if trips.length == 0
        average = 0
      else
        effective_length = trips.length - trips_in_progress
        average = ((total_ratings.to_f) / effective_length).round(2)
      end

      return average
    end

    def add_trip(trip)
      if trip.class != Trip
        raise ArgumentError.new("Can only add trip instance to trip collection")
      end

      @trips << trip
    end

    def accept_new_trip_assignment(trip)
      add_trip(trip)
      @status = :UNAVAILABLE
    end

    def total_revenue
      # NOTA BENE: THIS METHOD NEEDS TO NOT SHIT THE BED IF THERE
      # IS A TRIP WITH A COST OF NIL.
      overall_gross_revenue_array = @trips.map{ |trip| trip.cost }.reject{ |cost| cost.nil? }
  #    binding.pry
      fees_to_deduct = 1.65 * overall_gross_revenue_array.length
      @total_revenue = ((overall_gross_revenue_array.reduce(:+) - fees_to_deduct) * 0.8 ).round(2)
    end

    def average_revenue
      # THIS METHOD NEEDS TO ACCOUNT FOR CASES WHERE
      # THERE IS A TRIP IN PROGRESS (decrement by number of
      # in-progress trips)
      @average_revenue = (@total_revenue / @trips.length).round(2)
    end
  end
end
