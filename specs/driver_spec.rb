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
      @trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: pass, start_time: Time.parse("2015-05-20 12:14:00"), end_time: Time.parse("2015-05-20 12:39:00"), rating: 5})
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
      trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: nil, start_time: Time.parse("2015-05-20 12:14:00"), end_time: Time.parse("2015-05-20 12:39:00"), rating: 5})
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

  describe "net_income" do
    before do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")
      @driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
    end

    it "should calculate net income for all trips based on driver instance." do
      default_time = Time.now
      trip1 = RideShare::Trip.new({id: 8, driver: @driver, passenger: @passenger, start_time: default_time, end_time: default_time + (60 * 30), rating: 5, cost: 76.20})

      trip2 = RideShare::Trip.new({id: 8, driver: @driver, passenger: @passenger, start_time: default_time, end_time: default_time + (60 * 20), rating: 5, cost: 16.22})

      trip3 = RideShare::Trip.new({id: 8, driver: @driver, passenger: @passenger, start_time: default_time, end_time: default_time + (60 * 39), rating: 5, cost: 44.23})

      @driver.add_trip(trip1)
      @driver.add_trip(trip2)
      @driver.add_trip(trip3)

      subtotal = (76.20 + 16.22 + 44.23)

      @driver.net_income.must_equal((subtotal - 1.65) * 0.8)
    end

    it "return zero if driver has no trips" do
      @driver.net_income.must_equal 0
    end
  end

  describe "hourly_pay" do
    before do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")
      @driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
    end

    it "should calculate hourly pay for all trips based on driver instance." do
      default_time = Time.now
      trip1 = RideShare::Trip.new({id: 8, driver: @driver, passenger: @passenger, start_time: default_time, end_time: default_time + (60 * 30), rating: 5, cost: 76.20})

      trip2 = RideShare::Trip.new({id: 8, driver: @driver, passenger: @passenger, start_time: default_time, end_time: default_time + (60 * 20), rating: 5, cost: 16.22})

      trip3 = RideShare::Trip.new({id: 8, driver: @driver, passenger: @passenger, start_time: default_time, end_time: default_time + (60 * 39), rating: 5, cost: 44.23})

      @driver.add_trip(trip1)
      @driver.add_trip(trip2)
      @driver.add_trip(trip3)

      subtotal = (76.20 + 16.22 + 44.23)
      total_income = ((subtotal - 1.65) * 0.8)

      driving_time_seconds = ((60 * 30) + (60 * 20) + (60 * 39))


      driving_time_hours = (driving_time_seconds / 3600.0)


      hour_pay = (total_income / driving_time_hours)

      @driver.hourly_pay.must_equal(hour_pay)
    end

    it "return zero if driver has no trips" do
      @driver.hourly_pay.must_equal 0
    end
  end
end
