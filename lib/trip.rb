require 'csv'

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

      # -----------------
      # For the trips that are in_progress use:
      #change the rest of the current code to use it
      # def finish_trip!
      #   @end_time = Time.now
      # end
      #
      # def finished?
      #   return end_time !=nil
      # end

      # -----------------

      if @rating != nil
        if @rating > 5 || @rating < 1
          raise ArgumentError.new("Invalid rating #{@rating}")
        end
      end

      if @end_time != nil
        raise ArgumentError.new("End time cannot be before the start time.") if @start_time > @end_time
      end
    end

    def duration_method
      #change this name! haha

      if @end_time == nil
        return nil
      end

      return (@end_time.to_f - @start_time.to_f)
    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end
  end
end
