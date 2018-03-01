require 'time'
require_relative 'spec_helper'

describe "Trip class" do

  describe "initialize" do
    before do
      start_time = Time.parse("2015-05-20 12:14:00")
      end_time = Time.parse("2015-05-20 12:39:00")
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
      @trip_data[:start_time] = control_test_time
      @trip_data[:end_time] = control_test_time - 20
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
  describe 'duration' do
    before do
      start_time = Time.parse("2015-05-20 12:14:00")
      end_time = Time.parse("2015-05-20 12:39:00")
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

    it "returns duration of 0 if start and end times are the same." do
      control_test_time = Time.now

      @trip_data[:end_time] = control_test_time
      @trip_data[:start_time] = control_test_time

      RideShare::Trip.new(@trip_data).duration.must_equal 0
    end

    it "returns exact duration in seconds between start and end times." do
      control_test_time = Time.now

      @trip_data[:end_time] = control_test_time + 23
      @trip_data[:start_time] = control_test_time

      RideShare::Trip.new(@trip_data).duration.must_equal 23
    end
  end
  ##
end
