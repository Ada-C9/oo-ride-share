require 'csv'
require 'pry'
require 'awesome_print'

module RideShare
  class Trip
    attr_reader :id, :passenger, :driver, :cost, :rating
    attr_accessor :start_time, :end_time

    def initialize(input)
      @id = input[:id]
      @driver = input[:driver]
      @passenger = input[:passenger]
      @start_time = input[:start_time]
      @end_time = input[:end_time]

      @cost = input[:cost]
      @rating = input[:rating]

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

      convert_time
      check_time_validity


    end

    def convert_time
      if @start_time.class != Time
        @start_time = Time.parse(@start_time)
        @end_time = Time.parse(@end_time)
      end
    end

    def check_time_validity
      status = @start_time <=> @end_time
      if status != -1
        raise ArgumentError.new("Those are invalid times!")
      end
    end

    def duration
      duration = @end_time - @start_time
      return duration
    end

  end
end
