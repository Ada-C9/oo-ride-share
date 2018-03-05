# require 'time'

module RideShare

  # Throws ArgumentError is provided id is not an Integer greater than zero.
  # Otherwise, returns id.
  def self.return_valid_id_or_error(id)
    if id.class != Integer || id <= 0
      raise ArgumentError.new("ID (#{id}) cannot be nil or less than one.")
    end
    return id
  end

  # Throws ArgumentError is provided name is not a non-empty String. Otherwise,
  # returns name.
  def self.return_valid_name_or_error(name)
    if name.class != String|| name.strip.length.zero?
      raise ArgumentError.new("Name #{name} must be a non-empty String.")
    end
    return name
  end

  # Throws ArgumentError is provided driver is not a Driver. Otherwise returns
  # Driver.
  def self.return_valid_driver_or_error(driver)
    if driver.class != Driver
      raise ArgumentError.new("Driver #{driver} must be a driver.")
    end
    return driver
  end

  # Throws ArgumentError is provided trip is not a trip. Otherwise, returns trip.
  def self.return_valid_trip_or_error(trip)
    if trip.class != Trip
      raise ArgumentError.new("Trip #{trip} must be a valid trip.")
    end
    return trip
  end

  # Throws ArgumentError is provided trips is not an Array or if all elements in
  # trips are not Trips. Otherwise returns trips.
  def self.return_valid_trips_or_errors(trips)
    return [] if trips.nil?
    raise ArgumentError.new("#{trips} must be an Array") if trips.class != Array
    trips.each do |trip|
      return_valid_trip_or_error(trip)
    end
    return trips
  end

  # Throws ArgumentError is provided trips is not an Array or if all elements in
  # trips are not Trips
  # Returns the total amount in seconds of all completed trips.
  def self.get_all_trip_durations_in_seconds(trips)
    return_valid_trips_or_errors(trips)
    return 0 if trips.empty?
    return trips.inject(0) { |sum, trip| trip.is_in_progress? ? sum + 0 :
      sum + trip.get_duration }
  end

end
