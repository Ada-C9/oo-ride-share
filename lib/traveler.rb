module RideShare
  class Traveler
    attr_reader :trips

    def initialize (trips)
      @trips = trips || []
    end

  end
end 
