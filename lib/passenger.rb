
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

      # Did whoever gave us this input hash put any trip in it?
      # if input.keys.include? :trips => would be pretty much the same syntax
      #   @trips = input[:trips]
      # else
      #   @trips = []
      # end
      # above is the same as below
      @trips = input[:trips] == nil ? [] : input[:trips]
    end

    def get_drivers
      @trips.map{ |t| t.driver }
    end

    def add_trip(trip)
      @trips << trip
    end

    def money_spent
      total_passenger_cost = 0
      finish_trip.each do |trip|
        total_passenger_cost += trip.cost
      end
      return total_passenger_cost
    end

    def time_spent
      total_passenger_time = 0
      finish_trip.each do |trip|
        total_passenger_time += trip.duration
      end
      return total_passenger_time
    end

    def finish_trip
      trips.reject {|trip| trip.end_time == nil}
    end

  end # end of Passenger class
end # end of RideShare module

# testing_code = RideShare::Passenger.new(
# id: 21,
# name: "Lovelace",
# vin: "12345678912345678"
# trips: = RideShare::Trip.new({
# id: 21,
# driver: "Luxi",
# passenger: "Mark",
# start_time: Time.parse('2015-05-20T12:14:00+00:00'),
# end_time: Time.parse('2015-05-20T12:14:30+00:00'),
# cost: 25.00,
# rating: 3}))
#
# puts testing_code.money_spent
