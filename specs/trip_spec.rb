require 'time'
require_relative 'spec_helper'

describe "Trip class" do

  describe "initialize" do
    before do
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
      control_test_time = Time.now
      @trip_data[:start_time] = control_test_time.to_s
      @trip_data[:end_time] = '2015-05-20 12:39:00'
      proc {
        RideShare::Trip.new(@trip_data)
      }.must_raise ArgumentError
    end
    ##

    ## New Test
    it "must raise error if start_time or end_time are in the future." do
      control_test_time = Time.now
      @trip_data[:start_time] = (control_test_time + 1).to_s
      @trip_data[:end_time] = (control_test_time + 1).to_s
      proc {
        RideShare::Trip.new(@trip_data)
      }.must_raise ArgumentError

      @trip_data[:start_time] = (control_test_time - 1000).to_s
      @trip_data[:end_time] = (control_test_time + 1).to_s
      proc {
        RideShare::Trip.new(@trip_data)
      }.must_raise ArgumentError

      @trip_data[:start_time] = (control_test_time + 1).to_s
      @trip_data[:end_time] = (control_test_time - 1000).to_s
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
    ##
  end
  ## New Tests
  describe 'trip class' do
    before do
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
    it "returns an float for trip duration in seconds" do
      trip_duration_in_seconds = @trip.duration
      trip_duration_in_seconds.must_be_kind_of Float
    end

    it "trip duration: raises an error for end_time that precedes start_time" do
      control_test_time = Time.now
      @trip.start_time = control_test_time
      @trip.end_time = Time.parse("2015-05-20 12:39:00")
      proc {
        @trip.duration
      }.must_raise ArgumentError
    end
    it "returns an float for trip duration in seconds, even if trip is only 0 seconds long" do
      control_test_time = Time.now
      @trip.start_time = Time.parse("2015-05-20 12:39:00")
      @trip.end_time = control_test_time
      @trip.duration.must_be_kind_of Float

      @trip.start_time = control_test_time
      @trip.end_time = control_test_time
      @trip.duration.must_be_kind_of Float
      @trip.duration.must_equal 0.0
    end
  end
  ##
end
