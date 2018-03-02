# # Use this class to DRY passanger and driver by puting the methods they have duplicated in here
# module RideShare
#   class Traveler
#     attr_reader :trips
#
#     def initialize(trips)
#       @trips = trips || []
#       # @trips = input[:trips] == nil ? [] : input[:trips]
#     end
#
#     # def add_trip(trip)
#     #   if trip.class <= Trip
#     #     raise ArgumentError.new("Can only add trip instance to trip collection")
#     #   end
#     #
#     #   @trips << trip
#     # end
#
#   end
# end


# In the driver.rb

  # class Driver #< Traveler

# attr_reader :id, :name, :vehicle_id, :status , :trips #(take this :trip from here if using Traveler class)


# On initialize:

# super(input[:trips]) --> getting from Traveler
#  instead of:
# @trips = input[:trips] == nil ? [] : input[:trips]
