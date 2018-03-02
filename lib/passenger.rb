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

    def get_total_money
     total = 0
     @trips.each do |trip|
       total += trip.cost
     end
     return total
    end

    def total_time
      total = 0
      @trips.each do |trip|
        total = trip.end_time - trip.start_time
      end
      return total
    end


    def add_trip(trip)
      @trips << trip
    end
  end
end


 #pseudocode - describe "get total_rev do
#      it gets total revenue do"
#
#        this for the drivef spec
#
#        total;_rev =@drover.get_total_rev
#
#        total_rev.must_equal 1000
#
#
#        this for the driver.rb t
#        get total_rev method
#        total_rev starts at 0
#
#        iterate through each trip in all_trips
#        fee is 1.65
#        trip_cost
#        trip_rev(trip_cost - fee) * 0.8
