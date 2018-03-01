require 'csv'
require 'time'

module RideShare
  class Trip
    attr_reader :id, :passenger, :driver, :start_time, :end_time, :cost, :rating
    # could add status to whether a driver have completed his ride or still driving

    def initialize(input)
      @id = input[:id]
      @driver = input[:driver]
      @passenger = input[:passenger]
      @start_time = input[:start_time]
      @end_time = input[:end_time]
      @cost = input[:cost]
      @rating = input[:rating]


      # if @end_time != initialize@status = :completed
      # else
      #   @status = :incomplete
      # end_time

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

      if @end_time < @start_time
        raise ArgumentError.new("Invalid time")
      end
    end

    def duration
      return (@end_time - @start_time).to_i
    end

    # def finish_trip!
    #   @end_time = time.now
    # end
    #
    # def finished?
    #   return @end_time != nil
    # end



  end



end
