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

    it "raises error for invalid end time" do
      # @trip_data[:end_time] = Time.parse("2016-04-05T14:01:00+00:00")
      # @trip_data[:start_time] = Time.parse("2016-04-05T14:09:00+00:00")

      trip_data = {
        id: 8,
        driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: Time.parse("2016-04-05T14:09:00+00:00"),
        end_time: Time.parse("2016-04-05T14:01:00+00:00"),
        cost: 23.45,
        rating: 3
      }

      proc {
        RideShare::Trip.new(trip_data)
      }.must_raise ArgumentError
    end

    it "get duration of trip" do

      @trip.duration.must_equal 1500
      @trip.duration.must_be_instance_of Float
    end

    it "duration raises error if end_time nil" do
      new_trip_data = {
        id: 8,
        driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating:nil
      }

      inprogress_trip = RideShare::Trip.new(new_trip_data)
      #binding.pry
      proc{inprogress_trip.duration}.must_raise ArgumentError
    end

    #end
  end
end
