require 'csv'
require 'time'

module RideShare
  class Trip
    attr_reader :id, :passenger, :driver, :start_time, :end_time, :cost, :rating

    def initialize(input)
      @id = input[:id]
      @driver = input[:driver]
      @passenger = input[:passenger]
      #assigning value of zero if start time is nil
      @start_time = input[:start_time] ||= Time.parse('2016-04-05T14:01:00+00:00')
      #assigning value of zero if start time is nil
      @end_time = input[:end_time]
      @cost = input[:cost]
      @rating = input[:rating]

      #there is also a test for this in driver specs
      if @rating != nil && (@rating > 5 || @rating < 1 )
        raise ArgumentError.new("Invalid rating #{@rating}")
      end


      #p :hello
      if @end_time != nil && (@start_time > @end_time)
        raise ArgumentError.new("Invalid Trip Time")
      end

    end
    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end
    #returnst
    def length
      trip_length =  @end_time - @start_time
      #in seconds
      return  trip_length
    end
  end
end

# @trip_data = {
#   id: 8,
#   driver: "Lovelace",
#   passenger: "Passenger",
#   start_time: Time.parse('2015-05-20T12:14:00+00:00'),
#   end_time: Time.parse('2015-05-20T12:14:00+00:00')+ 25 * 60 ,
#   cost: 23.45,
#   rating: 3
# }
#
# a = RideShare::Trip.new(@trip_data)
# puts @trip_data[:start_time]
# puts @trip_data[:end_time]
#
#
# a.duration
