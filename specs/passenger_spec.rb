require_relative 'spec_helper'
require 'time'

describe "Passenger class" do

  describe "Passenger instantiation" do
    before do
      @passenger = RideShare::Passenger.new({id: 1, name: "Smithy", phone: "353-533-5334"})
    end

    it "is an instance of Passenger" do
      @passenger.must_be_kind_of RideShare::Passenger
    end

    it "throws an argument error with a bad ID value" do
      proc{ RideShare::Passenger.new(id: 0, name: "Smithy")}.must_raise ArgumentError
    end

    it "sets trips to an empty array if not provided" do
      @passenger.trips.must_be_kind_of Array
      @passenger.trips.length.must_equal 0
    end

    it "is set up for specific attributes and data types" do
      [:id, :name, :phone_number, :trips].each do |prop|
        @passenger.must_respond_to prop
      end

      @passenger.id.must_be_kind_of Integer
      @passenger.name.must_be_kind_of String
      @passenger.phone_number.must_be_kind_of String
      @passenger.trips.must_be_kind_of Array
    end
  end


  describe "trips property" do
    before do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723", trips: [])
      trip = RideShare::Trip.new({id: 8, driver: nil, passenger: @passenger, start_time: "2016-08-08T12:14:+300:008", end_time: "2016-08-08T12:15:00+00:00", rating: 5})

      @passenger.add_trip(trip)
    end

    it "each item in array is a Trip instance" do
      @passenger.trips.each do |trip|
        trip.must_be_kind_of RideShare::Trip
      end
    end

    it "all Trips must have the same Passenger id" do
      @passenger.trips.each do |trip|
        trip.passenger.id.must_equal 9
      end
    end
  end

  describe "get_drivers method" do
    before do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")
      driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
      trip = RideShare::Trip.new({id: 8, driver: driver, passenger: @passenger, start_time: "2016-08-08T12:14:+300:00", end_time: "2016-08-08T12:15:00+00:00", rating: 5})

      @passenger.add_trip(trip)
    end

    it "returns an array" do
      drivers = @passenger.get_drivers
      drivers.must_be_kind_of Array
      drivers.length.must_equal 1
    end

    it "all items in array are Driver instances" do
      @passenger.get_drivers.each do |driver|
        driver.must_be_kind_of RideShare::Driver
      end
    end
  end

  describe "total_spent" do
    it "return the total amount of money that passenger has spent on their trips" do
      trips = [
        RideShare::Trip.new({cost: 5, rating: 3, start_time: "2016-08-08T12:14:+300:00", end_time: "2016-08-08T12:15:00+00:00"}),
        RideShare::Trip.new({cost: 7, rating: 3, start_time: "2016-08-08T12:14:+300:00", end_time: "2016-08-08T12:15:00+00:00"}),
        RideShare::Trip.new({cost: 8, rating: 3, start_time: "2016-08-08T12:14:+300:00", end_time: "2016-08-08T12:15:00+00:00"})
      ]

      passenger_data = {
        id: 7,
        vin: 'a' * 17,
        name: 'test driver',
        trips: trips
      }

      passenger = RideShare::Passenger.new(passenger_data)
      passenger.total_spent.must_equal 20.00
    end
  end

  describe "total_time" do
    before do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 30
      trip_data = {
        id: 8,
        driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3
      }
      trip = RideShare::Trip.new(trip_data)
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")
      @passenger.add_trip(trip)
    end

    it "return the total amount of time that passenger has spent on their trips" do
      @passenger.total_time.must_equal 1800
    end
  end
end
