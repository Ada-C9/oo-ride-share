require_relative 'spec_helper'
require 'pry'

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

      @in_progress_trip_data = {
        id: 8,
        driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: Time.parse('2016-04-05T14:01:00+00:00'),
        end_time: nil,
        cost: nil,
        rating: nil
      }

      @trip = RideShare::Trip.new(@trip_data)
    end

    it "is an instance of Trip" do
      @trip.must_be_kind_of RideShare::Trip
    end

    it "raises an error if end_time is before start_time" do
      trip_data = {
        id: 8,
        driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: Time.parse('2016-04-05T14:09:00+00:00'),
        end_time: Time.parse('2016-04-05T14:01:00+00:00'),
        cost: 23.45,
        rating: 3
      }

      proc {
        RideShare::Trip.new(trip_data)
      }.must_raise ArgumentError
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

    it "allows rating to be nil" do
      proc {
        RideShare::Trip.new(@in_progress_trip_data)
      }.must_be_silent
    end

  end

  describe "duration" do

    before do
      @trip_data = {
        id: 8,
        driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: Time.parse('2016-04-05T14:01:00+00:00'),
        end_time: Time.parse('2016-04-05T14:09:00+00:00'),
        cost: 23.45,
        rating: 3
      }

      @in_progress_trip_data = {
        id: 8,
        driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: Time.parse('2016-04-05T14:01:00+00:00'),
        end_time: nil,
        cost: nil,
        rating: nil
      }
    end

    it "calculates the duration of a trip in seconds" do
      trip = RideShare::Trip.new(@trip_data)
      trip.duration_in_seconds.must_be_kind_of Float
    end

    it "returns zero if end_time is nil" do
      in_progress_trip = RideShare::Trip.new(@in_progress_trip_data)
      in_progress_trip.duration_in_seconds.must_equal 0
    end

  end
end
