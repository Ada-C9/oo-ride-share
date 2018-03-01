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

      start_time = Time.parse("2016-05-02T09:06:00+00:00")
      end_time = Time.parse("2016-06-02T22:05:00+00:00")

      @trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: pass, start_time: start_time, end_time: end_time, rating: 5})
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
      start_time = Time.parse("2015-12-14T05:19:00+00:00")
      end_time = Time.parse("2015-12-14T05:31:00+00:00")
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
      trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: nil, start_time: start_time, end_time: end_time, rating: 5})
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
      driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ", status: "UNAVAILABLE", trips: [])
      driver.average_rating.must_equal 0
    end
  end # end of describe "average_rating method"

  describe "calculate_total_revenue" do
    before do
      start_time = Time.parse("2016-11-21T18:43:00+00:00")
      end_time = Time.parse("2016-11-21T19:31:00+00:00")

      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
      trip = RideShare::Trip.new({id: 62, driver: @driver, passenger: nil, start_time: start_time, end_time: end_time, cost: 5.70, rating: 5})
      @driver.add_trip(trip)

      start_time = Time.parse("2015-12-14T05:19:00+00:00")
      end_time = Time.parse("2015-12-14T05:31:00+00:00")

      trip1 = RideShare::Trip.new({id: 62, driver: @driver, passenger: nil, start_time: start_time, end_time: end_time, cost: 23, rating: 4})
      @driver.add_trip(trip1)
    end

    it "returns a float" do
      @driver.calculate_total_revenue.must_be_kind_of Float
    end

    it "returns the correct total" do
      @driver.calculate_total_revenue.must_equal 20.32

    end
  end #end of describe "calculate_total_revenue"


  describe "calculate_total_trips_time_in_hours" do
    before do
      start_time = Time.parse("2016-11-21T18:43:00+00:00")
      end_time = Time.parse("2016-11-21T19:31:00+00:00")

      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")

      trip = RideShare::Trip.new({id: 62, driver: @driver, passenger: nil, start_time: start_time, end_time: end_time, cost: 9.06, rating: 5})

      @driver.add_trip(trip)

      start_time1 = Time.parse("2015-12-14T05:19:00+00:00")
      end_time1 = Time.parse("2015-12-14T05:46:00+00:00")

      trip1 = RideShare::Trip.new({id: 62, driver: @driver, passenger: nil, start_time: start_time1, end_time: end_time1, cost: 3.67, rating: 4})

      @driver.add_trip(trip1)
    end

    it "returns a sum of all times" do
      @driver.calculate_total_trips_time_in_hours.must_equal 1.25
    end

    it "returns 0 when no trips" do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")

      @driver.calculate_total_trips_time_in_hours.must_equal 0
    end
  end # end of describe calculate_total_trips_time_in_hours

  describe "calculate_avg_revenue_per_hour" do

    it "retruns a float at the expected rate" do

      start_time = Time.parse("2016-11-21T18:43:00+00:00")
      end_time = Time.parse("2016-11-21T19:31:00+00:00")

      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")

      trip = RideShare::Trip.new({id: 62, driver: @driver, passenger: nil, start_time: start_time, end_time: end_time, cost: 9.06, rating: 5})
      @driver.add_trip(trip)

      start_time1 = Time.parse("2015-12-14T05:19:00+00:00")
      end_time1 = Time.parse("2015-12-14T05:46:00+00:00")

      trip1 = RideShare::Trip.new({id: 62, driver: @driver, passenger: nil, start_time: start_time1, end_time: end_time1, cost: 3.67, rating: 4})
      @driver.add_trip(trip1)

      @driver.calculate_avg_revenue_per_hour.must_be_kind_of Float
      @driver.calculate_avg_revenue_per_hour.must_equal 6.03
    end

    it "returns an appropriate statement if no hours worked" do

  @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")

      @driver.calculate_avg_revenue_per_hour.must_equal 0
    end

    it "returns an appropriate statement if no revenue generated" do

      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")

      @driver.calculate_avg_revenue_per_hour.must_equal 0
    end

  end # end of describe calculate_avg_revenue_per_hour

end # end of describe Driver class
