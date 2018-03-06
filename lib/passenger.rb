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

      # did whoever give us this input hash put any trip in it?
      # you can also do this:
      if input.keys.include? :trips
        @trips = input[:trips]
      else
        @trips = []
      end

      # this was replaced by the above 5 lines of code
      # @trips = input[:trips] == nil ? [] : input[:trips]
      # @trips = input[:trips] || []
    end

    def get_drivers  # make this called "drivers"
      @trips.map{ |t| t.driver }
    end

    # Modify the passenger for the trip using a new helper method in Passenger:
    # Add the new trip to the collection of trips for the Passenger
    def add_trip(trip)
      @trips << trip
    end

    # Maybe make an in-progress helper method to reject any in-progress rides?



  end
end
