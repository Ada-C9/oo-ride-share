module RideShare
  class Passenger
    attr_reader :id, :name, :phone_number, :trips

    def initialize(input)
      if input[:id] == nil || input[:id] <= 0
        raise ArgumentError.new("ID cannot be blank or less than zero.")
      end

      @id = input[:id]
      @name = input[:name]
      @phone_number = input[:phone]
      @trips = input[:trips] == nil ? [] : input[:trips]
    end

    def get_drivers
      @trips.map{ |t| t.driver }
    end

    def add_trip(trip)
      @trips << trip
    end

    def get_total_spending
      finished_trips.map{|trip| trip.cost}.inject(0, :+).round(2)
    end

    def finished_trips
      trips_closed = @trips
      trips_closed.reject! {|trip| trip.end_time == nil || trip.cost == nil || trip.rating == nil }
      # trips_closed.each do |trip|
      #   if trip.end_time == nil || trip.cost == nil || trip.rating == nil
      #     trips_closed.delete(trip)
      #   end
      # end

      return trips_closed
    end

    def get_total_time
      finished_trips.map{|trip| trip.duration}.inject(0, :+).round(1)
    end

    def add_new_trip(trip)
      @trips << trip
    end

  end # Passenger class ends

end # Rideshare module ends
