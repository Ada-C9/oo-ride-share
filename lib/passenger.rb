require 'time'

module RideShare

  class Passenger
    attr_reader :id, :name, :phone_number, :trips

    @@total_amount_spent = 0
    @@total_time_spent = 0

    def initialize(input)
      if input[:id] == nil || input[:id] <= 0
        raise ArgumentError.new("ID cannot be blank or less than zero.")
      end

      @id = input[:id]
      @name = input[:name]
      @phone_number = input[:phone]
      @trips = input[:trips] == nil ? [] : input[:trips]
      # @trips needs to be an array
    end

    def get_drivers
      @trips.map{ |t| t.driver }
    end

    def add_trip(trip)
      @trips << trip

      total_time_spent += (trip.end_time - trip.start_time)
    end

    def total_amount_spent
    #   total_amount = 0
    #   if @trips.cost.nil?
    #     return
    #   else
    #     @trips.cost += total_amount
    #   end
    #   return total_amount
    # end
    #
    # def total_time_spent
    #   return @@total_time_spent
    end

  end
end


# Did whoever gave us this input hash put any trip in it?
# if input.keys.include? :trips
# @trips = input[:trips]
# else
# @trips = []
# end
