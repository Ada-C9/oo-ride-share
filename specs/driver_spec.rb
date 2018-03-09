require_relative 'spec_helper'

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
    it "Should create a kind of float " do
      tripss = []
      trip1 = RideShare::Trip.new(start_time: Time.parse("2016-04-05 14:01:00 +0000"), end_time: Time.parse("2016-04-05 14:02:00 +0000"), rating: 3, cost: 5)
      trip2 = RideShare::Trip.new(start_time: Time.parse("2016-04-05 14:01:00 +0000"), end_time: Time.parse("2016-04-05 14:05:00 +0000"), rating: 3, cost: 7)
      tripss << trip1
      tripss << trip2
      driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ", trips: tripss)
      driver.total_revenue.must_be_kind_of Float
      driver.total_revenue.must_equal (((5 - 1.65) + (7 - 1.65))* 0.8)
    end
  end

  describe "average_revenue_hour" do
    it "Should return a Float" do
      tripss = []
      trip1 = RideShare::Trip.new(start_time: Time.parse("2016-04-05 14:01:00 +0000"), end_time: Time.parse("2016-04-05 14:02:00 +0000"), rating: 3, cost: 5)
      trip2 = RideShare::Trip.new(start_time: Time.parse("2016-04-05 14:01:00 +0000"), end_time: Time.parse("2016-04-05 14:05:00 +0000"), rating: 3, cost: 7)
      tripss << trip1
      tripss << trip2
      driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ", trips: tripss)
      driver.average_revenue_hour.must_be_kind_of Float
      driver.average_revenue_hour.must_equal  83.52
      #(((5 - 1.65) + (7 - 1.65))* 0.8 / (5 / 60 ))

    end
  end

  describe "change_driver_status" do
    it "should change the drivers status" do
      ddriver = RideShare::Driver.new(id: 1, name: "George", vin: "33133313331333133", status: :AVAILABLE)
      ddriver.change_driver_status.must_equal :UNAVAILABLE
    end
  end

end
