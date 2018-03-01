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

    def add_trip(trip)
      if trip.class != Trip
        raise ArgumentError.new("Can only add trip instance to trip collection")
      end

      @trips << trip
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

    def change_status
      if @status == :AVAILABLE
        @status = :UNAVAILABLE
      else
        @status = :AVAILABLE
      end
    end

    def total_revenue
      total_revenue = 0
      trip_fee = 1.65
      @trips.each do |trip|
        if trip.cost < trip_fee
          total_revenue += trip.cost * 0.8
        else
          total_revenue += (trip.cost - trip_fee) * 0.8
        end
      end
      return total_revenue
    end

    def total_time
      total_time = 0
      @trips.each do |trip|
        total_time += trip.duration
      end
      return total_time
    end

    def revenue_per_hour
      return 0 if @trips.empty? || total_time == 0
      seconds_per_hr = 3600.0
      total_revenue_hrs = total_time / seconds_per_hr
      revenue_per_hour = total_revenue / total_revenue_hrs
      return revenue_per_hour
    end
  end
end
