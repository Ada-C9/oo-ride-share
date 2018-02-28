require_relative 'spec_helper'

describe "Driver class" do

  describe "Driver instantiation" do
    before do
      @driver = RideShare::Driver.new(id: 1, name: "George", vin: "33133313331333133")
    end

    it "001 is an instance of Driver" do
      @driver.must_be_kind_of RideShare::Driver
    end

    it "002 throws an argument error with a bad ID value" do
      proc{ RideShare::Driver.new(id: 0, name: "George", vin: "33133313331333133")}.must_raise ArgumentError
    end

    it "003 throws an argument error with a bad VIN value" do
      proc{ RideShare::Driver.new(id: 100, name: "George", vin: "")}.must_raise ArgumentError
      proc{ RideShare::Driver.new(id: 100, name: "George", vin: "33133313331333133extranums")}.must_raise ArgumentError
    end

    #how si this different from test 6?
    it "004 sets trips to an empty array if not provided" do
      @driver.trips.must_be_kind_of Array
      @driver.trips.length.must_equal 0
    end

    it "005 is set up for specific attributes and data types" do
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
      @trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: pass, date: Time.parse("2016-08-08"), rating: 5})
    end

    #different from 4?
    it "006 throws an argument error if trip is not provided" do
      proc{ @driver.add_trip(1) }.must_raise ArgumentError
    end

    it "007 increases the trip count by one" do
      previous = @driver.trips.length
      @driver.add_trip(@trip)
      @driver.trips.length.must_equal previous + 1
    end
  end

  describe " average_rating method" do
    before do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
      trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: nil, date: "2016-08-08", rating: 5})
      @driver.add_trip(trip)
    end

    it "008 returns a float" do
      @driver.average_rating.must_be_kind_of Float
    end

    it "009 returns a float within range of 1.0 to 5.0" do
      average = @driver.average_rating
      average.must_be :>=, 1.0
      average.must_be :<=, 5.0
    end

    it "010 returns zero if no trips" do
      driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
      driver.average_rating.must_equal 0
    end
  end

  describe "driver revenue method" do
    before do
      trips = [
        RideShare::Trip.new({cost: 5, rating: 3}),
        RideShare::Trip.new({cost: 7, rating: 3}),
        RideShare::Trip.new({cost: 8, rating: 3}),
      ]
      @driver_data = {
        id: 7,vin: 'a' * 17, name: 'test driver',
        trips: trip}
      end
    end

    it "011 returns the total revenue for the driver " do
      # Test 1: three trips
      driver = RideShare::Driver.new(@driver_data)
      driver.total_revenue.must_be_within_delta 12.04

    end

    it "012 if driver has taken no trips, returns nil for total_spent" do
      @driver_data = {
        id: 7,
        vin: 'a' * 17,
        name: 'test driver',
        trips: []}
        driver = RideShare::Driver.new(@driver_data)

        driver.total_revenue.must_be_nil
      end
    end
  end

  describe "average revenue method" do
    it "returns the average revenue for the driver" do
      trips = [
        RideShare::Trip.new({cost: 5, rating: 3}),
        RideShare::Trip.new({cost: 7, rating: 3}),
        RideShare::Trip.new({cost: 8, rating: 3}),
      ]
      @driver_data = {
        id: 7,
        vin: 'a' * 17,
        name: 'test driver',
        trips: trips}

        driver = RideShare::Driver.new(@driver_data)

        driver.avg_revenue.must_be_within_delta 4.01
      end
    end

  end
end
