require 'time'
require_relative 'spec_helper'

describe "Trip class" do

  describe "initialize" do
    before do
      # start_time = Time.parse('2015-05-20T12:14:00+00:00')
      # end_time = start_time + 25 * 60 # 25 minutes
      start_time = '2015-05-20T12:14:00+00:00'
      end_time = '2015-05-20 12:39:00'
      @trip_data = {
        id: 8,
        driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3
      }
      @trip = RideShare::Trip.new(@trip_data)
    end

    it "is an instance of Trip" do
      @trip.must_be_kind_of RideShare::Trip
    end

    it "stores an instance of passenger" do
      @trip.passenger.must_be_kind_of RideShare::Passenger
    end

    it "stores an instance of driver" do
      @trip.driver.must_be_kind_of RideShare::Driver
    end
    it "raises an error for an invalid rating" do
      [-3, 0, 6].each do |rating|
        @trip_data[:rating] = rating
        proc {
          RideShare::Trip.new(@trip_data)
        }.must_raise ArgumentError
      end
    end

    ## New Test
    it "raises an error for end_time that precedes start_time" do
      current_time = Time.now
      @trip_data[:start_time] = current_time.to_s
      @trip_data[:end_time] = '2015-05-20 12:39:00'
      proc {
        RideShare::Trip.new(@trip_data)
      }.must_raise ArgumentError
    end
    ##

    ## New Tests
    it "start_time and end_time values must be an instance of class time" do
      @trip.start_time.must_be_kind_of Time
      @trip.end_time.must_be_kind_of Time
    end
    # it "must raise error if start_time or end_time are in the future." do
    #   current_time = Time.now
    #   @trip.start_time = current_time
    #   @trip.end_time = current_time
    #
    #   if @start_time >= Time.now || @end_time >= Time.now
    #     must_raise ArgumentError ("Trips must occur in the past.")
    #   end
    # end
    # it "must raise error if end_time precedes start_time" do
    #   current_time = Time.now
    #   @trip.start_time = current_time
    #   initialize
    #   raise ArgumentError ("Startimes must precede endtimes")
    # end
    ##
  end
end
