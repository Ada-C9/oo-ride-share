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

    it "raises an error for end before start time" do
      trip_input = {
        id: 1,
        driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: "2017-04-05T14:01:00+00:00",
        end_time: "2016-04-05T14:01:00+00:00",
        cost: 20.00,
        rating: 5
      }
      proc {
        my_trip = RideShare::Trip.new(trip_input)
      }.must_raise(ArgumentError)
    end
  end

  describe "calculate_duration" do
    it "returns the correct amount of seconds for a 1 hour trip" do
      trip_input = {
        id: 1,
        driver: 12,
        passenger: 13,
        start_time: "2017-04-05T08:01:00+00:00",
        end_time: "2017-04-05T09:01:00+00:00",
        cost: 20.00,
        rating: 5}
      my_trip = RideShare::Trip.new(trip_input)
      my_trip.calculate_duration.must_equal(3600.0)
    end
  end
end
