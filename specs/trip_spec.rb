require_relative 'spec_helper'
require 'time'

describe "Trip class" do

  describe "initialize" do
    before do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
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


    it "raises an error for invalid end time" do
      # this is from "trips.csv" trip_id number 20, I reversed the start_time and end_time
      @trip_data[:start_time] = Time.parse("2016-02-16T13:14:00+00:00")
      @trip_data[:end_time] = Time.parse("2016-02-16T12:45:00+00:00")

      # # or should it be like this:
      # # start_time = @start_time[:start_time]
      # start_time = @trip_data[:start_time]
      # end_time = @trip_data[:end_time]
      #
      # start_time = Time.parse('2015-05-20T12:14:00+00:00')
      # end_time = start_time + 25 * 60 # 25 minutes

      proc {
        RideShare::Trip.new(@trip_data)
      }.must_raise ArgumentError

    end # ends 'it "raises an error for invalid end time" do'


  end # ends "describe "initialize" do"

  describe "duration" do
    it "tests duration of trip in seconds between end and start times" do
      # this is from "trips.csv" trip_id number 10, I reversed the start_time and end_time
      start_time = Time.parse("2015-12-14T12:55:00+00:00")
      end_time = Time.parse("2015-12-14T13:04:00+00:00")

      (end_time - start_time).must_equal 540



    end # ends "tests duration... do"


  end # ends "describe "duration" do"

end # ends "describe "Trip class" do"
