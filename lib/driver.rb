require 'csv'
require_relative 'trip'
# require_relative 'passenger' #take this out later
require 'time'

module RideShare
  class Driver
    attr_reader :id, :name, :vehicle_id, :status, :trips, :total

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

    def trip_in_progress(trip) #can I change status in a different method and just use add trip for in progress trips
      @status = :UNAVAILABLE
      @trips << trip
    end

    def total_revenue
      fee = 1.65
      driver_percent = 0.8

      subtotal = 0
      @trips.each do |trip|
        subtotal += trip.cost - fee
      end

      total = subtotal * driver_percent
      return total
    end

    def average_revenue_per_hour
      revenue = self.total_revenue
      total_drive_time = self.total_drive_time_hours

      average_revenue_per_hour = (revenue / total_drive_time)
      return average_revenue_per_hour
    end

    def total_drive_time_seconds #refactor all this time stuff somewhere. trip?
      total_drive_time_seconds = 0
      @trips.each do |trip|
        total_drive_time_seconds += trip.calculate_duration
      end
      return total_drive_time_seconds
    end

    def total_drive_time_hours #refactor all this time stuff somewhere. trip?
      total_drive_time_minutes = self.total_drive_time_seconds / 60
      total_drive_time_hours = total_drive_time_minutes / 60
      return total_drive_time_hours
    end


  end
end


# trips = [
#   RideShare::Trip.new({cost: 10.00, rating: 3, start_time: Time.parse("2016-04-05T14:01:00+00:00"), end_time: Time.parse("2016-04-05T16:01:00+00:00")})
# ]
# driver_data = {
#   id: 7,
#   vin: "e1e1e1e1e1e1e1e1e",
#   name: 'Speed Racer',
#   trips: trips
# }
# speedy = RideShare::Driver.new(driver_data)
# puts "Avg revenue per hour: #{speedy.average_revenue_per_hour}"
# puts "Total drive time in hours: #{speedy.total_drive_time_hours}"
