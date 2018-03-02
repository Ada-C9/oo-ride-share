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

end
