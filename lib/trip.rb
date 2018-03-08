require 'csv'

module RideShare
  class Trip
    attr_reader :id, :driver, :passenger, :start_time, :end_time, :cost, :rating

    def initialize(input)
      @id = input[:id]
      @driver = input[:driver]
      @passenger = input[:passenger]

      @start_time = input[:start_time]
      @end_time = input[:end_time]

      unless @start_time.nil? || @end_time.nil?
        if @start_time > @end_time
          raise ArgumentError.new("#{@end_time} is before #{@start_time}")
        end
      end

      @cost = input[:cost]
      @rating = input[:rating]

      unless @rating.nil?
        if @rating > 5 || @rating < 1
          raise ArgumentError.new("Invalid rating #{@rating}")
        end
      end
    end

    # returns nil as default instead of zero bc trip could be in progress in which case the duration is > 0
    def get_duration
      duration = nil
      if !@start_time.nil? && !@end_time.nil?
        duration = @end_time - @start_time
      end
      return duration
    end

    def self.total_time(trip_list)
      trip_list.map { |trip| trip.get_duration }.compact.sum
    end

    # def self.total_time(trip_list)
    #   trip_list.map { |trip| trip.get_duration }.compact.inject(0, :+)
    # end

    # # Alternative 1
    # def self.total_time(trip_list)
    #   trip_time = 0
    #   trip_list.each do |trip|
    #     unless trip.get_duration.nil?
    #       trip_time += trip.get_duration
    #     end
    #   end
    #   return trip_time
    # end

    def trip_in_progress?
      (self.start_time != nil && self.end_time == nil) ? true : false
    end

    # time in seconds; returns nil if trip in progress or no trips recorded
    def time_since_trip
      (Time.now - self.end_time) if self.end_time != nil
    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end

  end
end
