require 'pry'
require_relative 'spec_helper'

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
      trip = RideShare::Trip.new({id: 8, driver: nil, passenger: @passenger, start_time: Time.parse("2015-05-20 12:14:00"), end_time: Time.parse("2015-05-20 12:39:00"), rating: 5})

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
      trip = RideShare::Trip.new({id: 8, driver: driver, passenger: @passenger, start_time: Time.parse("2015-05-20 12:14:00"), end_time: Time.parse("2015-05-20 12:39:00"), rating: 5})

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

  describe "trips_total" do

    before do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")

      @driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
    end

    it "should calculate total amount of money spent for all trips based on passenger instance." do
      default_time = Time.now
      trip1 = RideShare::Trip.new({id: 8, driver: @driver, passenger: @passenger, start_time: default_time, end_time: default_time + (60 * 30), rating: 5, cost: 76.20})

      trip2 = RideShare::Trip.new({id: 8, driver: @driver, passenger: @passenger, start_time: default_time, end_time: default_time + (60 * 20), rating: 5, cost: 16.22})

      trip3 = RideShare::Trip.new({id: 8, driver: @driver, passenger: @passenger, start_time: default_time, end_time: default_time + (60 * 39), rating: 5, cost: 44.23})

      @passenger.add_trip(trip1)
      @passenger.add_trip(trip2)
      @passenger.add_trip(trip3)

      @passenger.trips_total.must_equal(76.20 + 16.22 + 44.23)
    end

    it "return zero if passengers have no trips" do
      @passenger.trips_total.must_equal 0
    end
  end

  describe "total_time" do
    before do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")

      @driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
    end

    it "returns the total time of all passenger trips in seconds" do
      default_time = Time.now
      trip1 = RideShare::Trip.new({id: 8, driver: @driver, passenger: @passenger, start_time: default_time, end_time: default_time + (60 * 30), rating: 5, cost: 76.20})

      trip2 = RideShare::Trip.new({id: 8, driver: @driver, passenger: @passenger, start_time: default_time, end_time: default_time + (60 * 20), rating: 5, cost: 16.22})

      trip3 = RideShare::Trip.new({id: 8, driver: @driver, passenger: @passenger, start_time: default_time, end_time: default_time + (60 * 39), rating: 5, cost: 44.23})

      @passenger.add_trip(trip1)
      @passenger.add_trip(trip2)
      @passenger.add_trip(trip3)

      @passenger.total_time.must_equal((60 * 30) + (60 * 20) + (60 * 39))
    end

    it "returns zero if all trips have zero duration." do
      default_time = Time.now
      trip1 = RideShare::Trip.new({id: 8, driver: @driver, passenger: @passenger, start_time: default_time, end_time: default_time, rating: 5, cost: 76.20})

      trip2 = RideShare::Trip.new({id: 8, driver: @driver, passenger: @passenger, start_time: default_time, end_time: default_time, rating: 5, cost: 16.22})

      trip3 = RideShare::Trip.new({id: 8, driver: @driver, passenger: @passenger, start_time: default_time, end_time: default_time, rating: 5, cost: 44.23})

      @passenger.add_trip(trip1)
      @passenger.add_trip(trip2)
      @passenger.add_trip(trip3)

      @passenger.total_time.must_equal 0
    end

    it "it returns zero if passenger has no trips." do
      @passenger.total_time.must_equal 0
    end
  end
end
