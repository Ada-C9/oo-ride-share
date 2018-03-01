require_relative 'spec_helper'

xdescribe "Driver class" do
  before do
    # 1,Bernardo Prosacco,WBWSS52P9NEYLVDE9,UNAVAILABLE
    # 1,1,54,2016-04-05T14:01:00+00:00,2016-04-05T14:09:00+00:00,17.39,3
    # 122,1,247,2015-12-24T04:57:00+00:00,2015-12-24T04:57:00+00:00,13.11,5
    @trip_1 = RideShare::Trip.new(id: 1, driver: 1, passenger: 54, start_time: Time.parse('2016-04-05T14:01:00+00:00'), end_time: Time.parse('2016-04-05T14:09:00+00:00'), cost: 17.39, rating: 3)
    @trip_2 = RideShare::Trip.new(id: 122, driver: 1, passenger: 247, start_time: Time.parse('2015-12-24T04:57:00+00:00'), end_time: Time.parse('2015-12-24T04:57:00+00:00'), cost: 13.11, rating: 5)
    @driver = RideShare::Driver.new(id: 1, name: "Bernardo Prosacco", vin: "WBWSS52P9NEYLVDE9", status: :UNAVAILABLE, trips: [])
  end


  xdescribe "Driver instantiation" do
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

  xdescribe "add trip method" do
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

  xdescribe "average_rating method" do
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
    it "calculates the driver total revenue" do
      @driver.add_trip(@trip_1)
      @driver.add_trip(@trip_2)
      @driver.total_revenue.must_equal (17.39 + 13.11 - 1.65) * 0.8
    end

    it "returns 0 if there is no trip for this driver" do
      @driver.total_revenue.must_equal 0
    end
  end

  describe "average_revenue per hour" do
    it "calculates the driver average revenue" do
      @driver.add_trip(@trip_1)
      @driver.add_trip(@trip_2)
      @driver.average_revenue.must_equal (17.39 + 13.11 - 1.65) * 0.8 / 2.round(2)
    end
  end
end
