require 'csv'
require_relative 'trip'

module RideShare
  class Driver
    attr_reader :id, :name, :vehicle_id, :status, :trips

    EMPLOYER_FEE = 1.65
    TAKEHOME_RATE = 0.8

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

    def get_revenue
      subtotal = 0

      @trips.each do |trip|
        unless trip.cost <= EMPLOYER_FEE
          subtotal += trip.cost - EMPLOYER_FEE
        end
      end
      revenue = subtotal * TAKEHOME_RATE
      return revenue.round(2)
    end

    # # Alternative 1
    # def get_revenue
    #   @trips.map { |trip|
    #     trip.cost >= EMPLOYER_FEE ? (trip.cost - EMPLOYER_FEE) * TAKEHOME_RATE : 0
    #   }.inject(0, :+)
    # end

    # # Alternative 2
    # def get_revenue
    #   @trips.map { |trip|
    #     if trip.cost <= EMPLOYER_FEE
    #       0
    #     else
    #       (trip.cost - EMPLOYER_FEE) * TAKEHOME_RATE
    #     end
    #   }.inject(0, :+)
    # end

    def get_total_time
      Trip.total_time(@trips)
    end

    def get_revenue_per_hour
      return 0 if self.trips.empty?
      (self.get_revenue / self.get_total_time * 3600).round(2)
    end

    def self.available_driver
      self.find {|driver| driver.status == :AVAILABLE}
    end

  end
end
