require 'csv'

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

    def change_status
      if @status == :AVAILABLE
        @status = :UNAVAILABLE
      else
        @status = :AVAILABLE
      end
    end

    def add_trip(trip)
      if trip.class != Trip
        raise ArgumentError.new("Can only add trip instance to trip collection")
      end

      @trips << trip
    end

    def average_rating
      sum_ratings = completed_trips.map { |trip| trip.rating }.reduce(0,:+)

      if completed_trips.empty?
        average = 0
      else
        average = (sum_ratings.to_f) / completed_trips.length
      end

      return average
    end

    def total_revenue
      trip_fee = 1.65
      driver_share = 0.8

      total_revenue = 0

      # does not apply trip fee if cost of trip is <= trip fee
      completed_trips.each do |trip|
        if trip_fee > trip.cost
          total_revenue += trip.cost * driver_share
        else
          total_revenue += (trip.cost - trip_fee) * driver_share
        end
      end

      return total_revenue
    end

    def total_time
      completed_trips.map { |trip| trip.duration }.reduce(0,:+)
    end

    def revenue_per_hour
      return 0 if completed_trips.empty? || total_time == 0

      seconds_per_hour = 3600.0
      total_revenue_hrs = total_time / seconds_per_hour
      revenue_per_hour = total_revenue / total_revenue_hrs

      return revenue_per_hour
    end

    def completed_trips
      @trips.select { |trip| trip.is_finished? }
    end
  end
end
