require 'csv'
require 'time'

module RideShare

  def self.return_valid_trip_or_error(trip)
    if trip.class != Trip
      raise ArgumentError.new("Can only add trip instance to trip collection")
    end
    return trip
  end

  def self.return_valid_id_or_error(id)
    if id.class != Integer || id <= 0
      raise ArgumentError.new("ID (#{id}) cannot be nil or less than zero.")
    end
    return id
  end

  def self.return_valid_name_or_error(name)
    if name.class != String|| name.strip.length.zero?
      raise ArgumentError.new("Name #{name} must be a non-empty String.")
    end
    return name
  end

  def self.valid_trips_or_errors(input_trips)
    input_trips.each { |trip| return_valid_trip_or_error(trip) }
    return input_trips
  end


  class Trip
    attr_reader :id, :passenger, :driver, :start_time, :end_time, :cost, :rating

    def initialize(input)
      @id = input[:id]
      @driver = valid_driver_or_error(input[:driver])
      @passenger = input[:passenger]
      @start_time = valid_time_or_error(input[:start_time])
      @end_time = input[:end_time]
      @cost = input[:cost]
      @rating = valid_rating_or_error(input[:rating])
      valid_trip_duration_or_error
    end

    def get_duration
      return (@end_time - @start_time).to_i
    end

    def is_in_progress?
      return @end_time.nil?
    end

    private


    def valid_rating_or_error(rating)
      if !is_in_progress? && (rating > 5 || rating < 1)
        raise ArgumentError.new("Invalid rating #{rating}")
      end
      return rating
    end

    def valid_trip_duration_or_error
      if !is_in_progress? && get_duration < 0.0
        raise ArgumentError.new("Invalid duration #{get_duration}")
      end
    end

    def valid_time_or_error(time)
      if time.class != Time
        raise ArgumentError.new("Invalid time #{time}")
      end
      return time
    end

    def valid_driver_or_error(driver)
      if driver.class != Driver
        raise ArgumentError.new("Driver #{driver} must be a driver.")
      end
      return driver
      # return assign_to_driver_or_error(driver)
    end

    # def assign_to_driver_or_error(driver) # Test for this!
    #   if is_in_progress? && driver.trips.last != self
    #     driver.is_available? ? driver.add_trip(self) : driver_unavailable_error
    #   end
    #   return driver
    # end

    # def driver_unavailable_error
    #   raise ArgumentError.new("Cannot add trip to unavailable driver")
    # end

  end
end
