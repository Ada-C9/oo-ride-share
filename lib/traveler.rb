# 2/28/18
# Group session with Charles
# Wave 2 update
# => we are going to create a new class to take in the method that
# => exist in multiple classes
# => this is to help DRY up the driver and passenger classes

# Traveler is the parent class for Driver class
module RideShare
  class Traveler
    attr_reader :trips

    def initialize()
      @trips = trip || []
    end


  end # end of Traveler class
end # end of RideShare module
