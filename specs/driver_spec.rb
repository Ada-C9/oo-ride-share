require_relative 'spec_helper'
require 'pry'

describe "Driver class" do

  describe "Driver instantiation" do
    before do
      @driver = RideShare::Driver.new(id: 1, name: "George", vin: "33133313331333133")
    end

    it "is an instance of Driver" do
      @driver.must_be_kind_of RideShare::Driver
    end

    it "throws an argument error with a bad ID value" do
      proc{ RideShare::Driver.new(id: 0, name: "George", vin: "33133313331333133")}.must_raise ArgumentError
    end

    it "throws an argument error with a bad VIN value" do
      proc{ RideShare::Driver.new(id: 100, name: "George", vin: "")}.must_raise ArgumentError
      proc{ RideShare::Driver.new(id: 100, name: "George", vin: "33133313331333133extranums")}.must_raise ArgumentError
    end

    it "sets trips to an empty array if not provided" do
      @driver.trips.must_be_kind_of Array
      @driver.trips.length.must_equal 0
    end

    it "is set up for specific attributes and data types" do
      [:id, :name, :vehicle_id, :status].each do |prop|
        @driver.must_respond_to prop
      end

      @driver.id.must_be_kind_of Integer
      @driver.name.must_be_kind_of String
      @driver.vehicle_id.must_be_kind_of String
      @driver.status.must_be_kind_of Symbol
    end
  end

  describe "add trip method" do
    before do
      pass = RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640")
      @driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
      @trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: pass, date: "2016-08-08", rating: 5})
    end

    it "throws an argument error if trip is not provided" do
      proc{ @driver.add_trip(1) }.must_raise ArgumentError
    end

    it "increases the trip count by one" do
      previous = @driver.trips.length
      @driver.add_trip(@trip)
      @driver.trips.length.must_equal previous + 1
    end
  end

  describe "average_rating method" do
    before do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
      trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: nil, date: "2016-08-08", rating: 5})
      trip2 = RideShare::Trip.new({id: 8, driver: @driver, passenger: nil, start_time: "2016-04-06T14:01:00+00:00"})
      @driver.add_trip(trip)
      @driver.add_trip(trip2)
    end

    it "returns a float" do
      @driver.average_rating.must_be_kind_of Float
    end

    it "returns a float within range of 1.0 to 5.0" do
      average = @driver.average_rating
      average.must_be :>=, 1.0
      average.must_be :<=, 5.0
    end

    it "returns zero if no trips" do
      driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
      driver.average_rating.must_equal 0
    end
  end

  describe "total_revenue method" do
    it "must return the total amount made by a driver" do
      driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
      passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")

      trip1 = RideShare::Trip.new({id: 8, driver: driver, passenger: passenger, cost: 10, start_time: "2016-04-06T14:01:00+00:00", end_time: "2016-04-06T14:09:00+00:00", rating: 5})

      trip2 = RideShare::Trip.new({id: 8, driver: driver, passenger: passenger, cost: 15.00, rating: 3, start_time: "2016-04-06T14:01:00+00:00", end_time: "2016-04-06T14:09:00+00:00"})

      driver.add_trip(trip1)
      driver.add_trip(trip2)
      driver.total_revenue.must_equal 17.36
    end

    it "must return zero if no trips have been made" do
      driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")

      driver.total_revenue.must_equal 0
    end
  end

  describe "avg_revenue" do
    it "must return the average amount made per hour for a driver" do
      driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
      passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")

      trip1 = RideShare::Trip.new({id: 8, driver: driver, passenger: passenger, cost: 10, start_time: "2016-04-06T14:01:00+00:00", end_time: "2016-04-06T14:09:00+00:00", rating: 5})

      trip2 = RideShare::Trip.new({id: 8, driver: driver, passenger: passenger, cost: 15.00, rating: 3, start_time: "2016-04-06T14:01:00+00:00", end_time: "2016-04-06T14:09:00+00:00"})

      driver.add_trip(trip1)
      driver.add_trip(trip2)

      driver.avg_revenue.must_equal 64.30
    end

    it "must return zero if a driver made no trips" do
      driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")

      driver.avg_revenue.must_equal 0
    end
  end
end
