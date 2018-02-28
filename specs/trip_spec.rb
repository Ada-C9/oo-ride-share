require_relative 'spec_helper'
require 'pry'

describe "Trip class" do

  describe "initialize" do
    before do

      @trip_data = {
        id: 8,
        driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: '2015-05-20T12:14:00+00:00',
        end_time: '2015-05-20T12:14:30+00:00',
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
  end

  describe "convert_time" do
    before do
      @trip_data = {
        id: 8,
        driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: "2015-05-20T12:14:00+00:00",
        end_time: "2015-05-20T12:14:30+00:00",
        cost: 23.45,
        rating: 3
      }
      @trip = RideShare::Trip.new(@trip_data)
    end


    it "converts string time to Time class" do
    @trip.start_time.must_be_kind_of Time
    @trip.end_time.must_be_kind_of Time
    end
  end

  describe "check_time_validity" do
    before do
      @trip_data = {
        id: 8,
        driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: "2015-05-20T12:14:00+00:00",
        end_time: "2014-05-20T12:14:00+00:00",
        cost: 23.45,
        rating: 3
      }
    end


    it "raises argument error if end time is before start time" do
      proc { @trip = RideShare::Trip.new(@trip_data)}.must_raise ArgumentError
    end
  end

  describe "duration" do
    before do
      @trip_data = {
        id: 8,
        driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: "2015-05-20T12:14:00+00:00",
        end_time: "2015-05-20T12:15:0+00:00",
        cost: 23.45,
        rating: 3
      }
      @trip = RideShare::Trip.new(@trip_data)
    end

    it "calculates duration in seconds" do
      @trip.duration.must_equal 60
    end

  end
end
