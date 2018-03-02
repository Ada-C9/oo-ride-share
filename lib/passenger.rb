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

    def total_money_spent
      total_money_spent = 0
      @trips.each{|trip|
        total_money_spent += trip.cost if !trip.end_time.nil?}
      return total_money_spent.round(2)
    end

    def total_time_spent
      # total_time_spent = 0
      # @trips.each{|trip|
      #   total_time_spent += trip.duration}
      # return total_time_spent.round
      return @trips.reduce(0) { |total_time, trip| total_time + (trip.end_time.nil? ? 0 : trip.duration) }.round
    end

    def get_drivers
      @trips.map{ |t| t.driver }
    end

    def add_trip(trip)
      @trips << trip
    end

  end
end
