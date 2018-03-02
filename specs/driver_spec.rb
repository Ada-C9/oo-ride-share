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
  end # Instantiation

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
  end # Add Trip

  describe "average_rating method" do
    before do
      start_time = Time.parse("2016-02-16T12:45:00+00:00")
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
      trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: nil, start_time: start_time, end_time: start_time + 25 * 60, rating: 5})
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

    it "accurately ignores trips in progress" do
      start_time = Time.parse("2016-02-16T12:45:00+00:00")
      driver = RideShare::Driver.new({id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ", trips: [RideShare::Trip.new({rating:3, cost:27, start_time: start_time, end_time: start_time + 25 * 60}), RideShare::Trip.new({rating:3,cost:14.87, start_time: start_time, end_time: start_time + 25 * 60}), RideShare::Trip.new({start_time: start_time})]})

      expected_rating = 3
      result = driver.average_rating
      result.must_equal expected_rating

      end
    end # average rating

    describe "#total_revenue" do
      it "returns accurate total revenue" do
        start_time = Time.parse("2016-02-16T12:45:00+00:00")
        trips = [
          RideShare::Trip.new({cost:14.8, rating: 3, start_time: start_time, end_time: start_time + 25 * 60}),
          RideShare::Trip.new({cost:50, rating: 3, start_time: start_time, end_time: start_time + 25 * 60}),
          RideShare::Trip.new({cost:27, rating: 3, start_time: start_time, end_time: start_time + 25 * 60})
        ]
        driver = RideShare::Driver.new({id:56, vin:"a"*17, trips: trips})

        expected_revenue = 69.48
        result = driver.total_revenue
        result.must_equal expected_revenue
      end

      it "returns zero if the driver does not have any trips" do
        driver = RideShare::Driver.new({ id:56, vin:"a"*17})
        expected_revenue = 0
        result = driver.total_revenue
        result.must_equal expected_revenue
      end

      it "does not return a negative revenue" do
        trips = [RideShare::Trip.new({cost:1.30, rating: 3}), RideShare::Trip.new({cost:1.25, rating: 3}), RideShare::Trip.new({cost:1.03, rating: 3})]
        driver = RideShare::Driver.new({id:56, vin:"a"*17, trips: trips})
        expected_revenue = 0
        result = driver.total_revenue
        result.must_equal expected_revenue
      end

      it "accurately ignores trips in progress" do
        start_time = Time.parse("2016-02-16T12:45:00+00:00")
        driver = RideShare::Driver.new({id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ", trips: [RideShare::Trip.new({rating:3, cost: 10.65, start_time: start_time, end_time: start_time + 25 * 60}), RideShare::Trip.new({rating:3,cost:7.65, start_time: start_time, end_time: start_time + 25 * 60}), RideShare::Trip.new({start_time: start_time})]})

        expected_revenue = 12
        result = driver.total_revenue
        result.must_equal expected_revenue
      end

    end # total_revenue

    describe "#ave_revenue_per_hour" do

      it "returns average revenue of trips" do
        start_time = Time.parse("2016-05-24T15:37:00+00:00")
        trips = [
          RideShare::Trip.new({cost: 45, rating: 3, start_time: start_time, end_time: start_time + 35 * 60}),
          RideShare::Trip.new({cost: 32, rating: 3, start_time: start_time, end_time: start_time + 25 * 60})
        ]
        driver = RideShare::Driver.new({id: 63, vin:"a"*17, trips: trips})
        expected_average = 58.96
        result = driver.ave_revenue_per_hour
        result.must_equal expected_average
      end


      it "returns zero if driver has no trips" do
        driver = RideShare::Driver.new({id: 63, vin:"a"*17})
        expected_average = 0
        result = driver.ave_revenue_per_hour
        result.must_equal expected_average
      end

      it "accurately ignores trips in progress" do
        start_time = Time.parse("2016-02-16T12:45:00+00:00")
        driver = RideShare::Driver.new({id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ", trips: [RideShare::Trip.new({rating:3, cost: 10.65, start_time: start_time, end_time: start_time + 20 * 60}), RideShare::Trip.new({rating:3,cost:7.65, start_time: start_time, end_time: start_time + 40 * 60}), RideShare::Trip.new({start_time: start_time})]})

        expected_average = 12
        result = driver.ave_revenue_per_hour
        result.must_equal expected_average
      end

    end # ave_revenue_per_hour

  end # Describe driver Class
