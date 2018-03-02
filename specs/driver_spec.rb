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
      proc{
        RideShare::Driver.new(id: 100, name: "George", vin: "")
      }.must_raise ArgumentError
      proc{
        RideShare::Driver.new(id: 100, name: "George", vin: "33133313331333133extranums")
      }.must_raise ArgumentError
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
      @trip = RideShare::Trip.new(
        {id: 8, driver: @driver, passenger: pass, start_time: Time.parse('2016-01-13T13:16:00+00:00'), end_time: Time.parse('2016-01-13T13:28:00+00:00'), rating: 5}
      )
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
      trip = RideShare::Trip.new(
        {id: 8, driver: @driver, passenger: nil, start_time: Time.parse('2016-01-13T13:16:00+00:00'), end_time: Time.parse('2016-01-13T13:28:00+00:00'), rating: 5}
      )
      @driver.add_trip(trip)
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

  describe "total_revenue" do
    before do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ", trips: nil)

      trip = RideShare::Trip.new(
        {id: 8, driver: @driver, passenger: nil, start_time: Time.parse('2016-01-13T13:16:00+00:00'), end_time: Time.parse('2016-01-13T13:28:00+00:00'), cost: 5.50, rating: 5}
      )
      @driver.add_trip(trip)
    end

    it "returns total earnings with 1 trip" do
      @driver.total_revenue.must_be_instance_of Float
      @driver.total_revenue.must_be_within_delta 3.08
    end

    it "returns total earnings for driver with 2 trips" do
      trip2 = RideShare::Trip.new(
        {id: 8, driver: @driver, passenger: nil, start_time: Time.parse('2016-01-13T13:16:00+00:00'), end_time: Time.parse('2016-01-13T13:28:00+00:00'), cost: 9.75, rating: 5}
      )
      @driver.add_trip(trip2)
      @driver.total_revenue.must_be_within_delta 9.56
    end

    it "returns total earnings for a driver with a nil end_time" do
      current_trip = RideShare::Trip.new(
        {id: 8, driver: @driver, passenger: nil, start_time: Time.parse('2016-01-13T13:16:00+00:00'), end_time: nil, cost: nil, rating: nil}
      )
      @driver.total_revenue.must_be_instance_of Float
      @driver.total_revenue.must_be_within_delta 3.08
    end

    it "returns total_revenue of 3.08 for trip with negative cost" do
      trip2 = RideShare::Trip.new(
        {id: 8, driver: @driver, passenger: nil, start_time: Time.parse('2016-01-13T13:16:00+00:00'), end_time: Time.parse('2016-01-13T13:28:00+00:00'), cost: -6.0, rating: 5}
      )
      @driver.add_trip(trip2)
      @driver.total_revenue.must_be_within_delta 3.08
      end
  end

  describe "rate" do
    before do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
    end

    it 'returns accurate information for driver with no payments' do
      @driver.add_trip(
        RideShare::Trip.new({id: 9, driver: @driver, passenger: nil, start_time: Time.parse('2016-01-13T13:16:00+00:00'), end_time: Time.parse('2016-01-13T13:28:00+00:00'), cost: nil, rating: 5})
      )
      @driver.rate.must_equal 0
    end

    it 'returns accurate information for driver with 1 payment' do
      @driver.add_trip(
        RideShare::Trip.new({id: 9, driver: @driver, passenger: nil, start_time: Time.parse('2016-01-13T13:16:00+00:00'), end_time: Time.parse('2016-01-13T13:28:00+00:00'), cost: 19.50, rating: 5})
      )
      @driver.rate.must_be_kind_of Float
      @driver.rate.must_be_within_delta 71.4
    end

    it 'returns accurate information for driver with 2 payments' do
      @driver.add_trip(
        RideShare::Trip.new({id: 9, driver: @driver, passenger: nil, start_time: Time.parse('2015-01-13T13:16:00+00:00'), end_time: Time.parse('2015-01-13T13:28:00+00:00'), cost: 15.50, rating: 5})
      )
      @driver.add_trip(
        RideShare::Trip.new({id: 9, driver: @driver, passenger: "Stephanie Wu", start_time: Time.parse('2016-02-13T13:16:00+00:00'), end_time: Time.parse('2016-02-13T13:28:00+00:00'), cost: 19.50, rating: 5})
      )
      @driver.rate.must_be_kind_of Float
      @driver.rate.must_be_within_delta 63.4
    end

    it 'returns accurate rate for driver with a nil end_time' do
      @driver.add_trip(
        RideShare::Trip.new({id: 9, driver: @driver, passenger: nil, start_time: Time.parse('2016-01-13T13:16:00+00:00'), end_time: Time.parse('2016-01-13T13:28:00+00:00'), cost: 19.50, rating: 5})
      )
      @driver.add_trip(
        RideShare::Trip.new({id: 9, driver: @driver, passenger: "Stephanie Wu", start_time: Time.parse('2016-02-13T13:16:00+00:00'), end_time: nil, cost: nil, rating: nil})
      )
      @driver.rate.must_be_kind_of Float
      @driver.rate.must_be_within_delta 71.4
    end
  end

  describe "unavailble method" do
    it "changes a driver's status to :UNAVAILABLE when invoked" do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
      @driver.unavailable
      @driver.status.must_equal :UNAVAILABLE
    end
  end
end
