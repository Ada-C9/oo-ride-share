require 'csv'
require 'time'
require 'pry'

module RideShare
  class Trip
    attr_reader :id, :passenger, :driver, :start_time, :end_time, :cost, :rating

    def initialize(input)
      @id = input[:id]
      @driver = input[:driver]
      @passenger = input[:passenger]
      @start_time = input[:start_time]
      @end_time = input[:end_time]
      @cost = input[:cost]
      @rating = input[:rating]

      # if @end_time != nil
      #   @status = :COMPLETE
      # else
      #   @status = :INCOMPLETE
      # end

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

      if @start_time > @end_time
        raise ArgumentError.new("End time: #{@end_time} cannot be earlier than Start time: #{@start_time}")
      end
    end

    def duration
      (end_time - start_time).to_i
    end

    # def finish_trip!
    #   @end_time = Time.now
    # end

    # def finished?
    #   return end_time != nil
    # end

  end # end of Trip class
end # end of RideShare module

# testing_code = RideShare::Trip.new(
# id: 21,
# driver: "Luxi",
# passenger: "Mark",
# start_time: Time.parse('2015-05-20T12:14:00+00:00'),
# end_time: Time.parse('2015-05-20T12:14:30+00:00'),
# cost: 25.00,
# rating: 3
# )
# puts testing_code.duration
