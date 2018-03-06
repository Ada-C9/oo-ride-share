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
      @trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: pass, start_time: "2016-08-08", end_time: "2016-08-08T16:01:00+00:00", rating: 5})
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
      trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: nil, start_time: "2016-08-08", end_time: "2016-08-08T10:42:00+00:00", rating: 5})
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
    end # ends 'it "returns zero if no trips" do'
  end # ends 'describe "average_rating method" do'


  describe "total_revenue method" do
    it "calculates the total revenue" do
      trips = [
        RideShare::Trip.new({cost: 17.39, rating: 3, start_time: "2016-04-05T14:01:00+00:00", end_time: "2016-04-05T14:09:00+00:00"}),
        RideShare::Trip.new({cost: 17.12, rating: 3, start_time: "2016-01-13T13:16:00+00:00", end_time: "2016-01-13T13:28:00+00:00"}),
        RideShare::Trip.new({cost: 21.88, rating: 3, start_time: "2016-05-02T09:06:00+00:00", end_time: "2016-05-02T09:56:00+00:00"})
      ]
      driver_data = {
        id: 7,
        vin: 'a' * 17,
        name: 'test driver',
        trips: trips
      }
      driver = RideShare::Driver.new(driver_data)
      driver.total_revenue.must_equal 41.152

    end # ends 'it "calculates the total revenue" do'
  end # ends 'describe "total_revenue method" do'

  describe "average_revenue" do
    before do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")

      trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: nil, start_time: "2016-08-08", end_time: "2016-08-08T10:42:00+00:00", rating: 5})

      @driver.add_trip(trip)
    end

    # it "checks average_revenue method" do
    #   # data from trips.csv id 20
    #   start_time = Time.parse("2016-02-16T12:45:00+00:00")
    #   end_time = start time + 60 * 60
    #
    #   trip_data1 = {
    #     id: @id,
    #     driver: @driver,
    #     passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723"),
    #     start_time: start_time, # <-- looks for start_time or a local variable
    #     end_time: end_time,
    #     cost: 50,
    #     rating: 3
    #   }
    #
    #   trip_data2 = {id: @id,
    #     driver: @driver,
    #     passenger = RideShare::Passenger.new(id: 1, name: "Nina Hintz Sr.", phone: "560.815.3059"),
    #     start_time: start_time, # <-- looks for start_time or a local variable
    #     end_time: end_time,
    #     cost: 40,
    #     rating: 4
    #     # 3,8,2016-02-05T16:42:00+00:00,2016-02-05T17:02:00+00:00,27.39,1
    #   }
    #   trip = RideShare::Trip.new(trip_data1)
    #   @driver.add_trip(trip1)
    #   trip = RideShare::Trip.new(trip_data2)
    #   @driver.add_trip(trip2)
    #
    # end # ends "it "checks average_revenue method" do"

    it "calculates the driver's average_revenue per hour spent driving (using the above formula for revenue)" do
      @driver.average_revenue.must_equal 1010101010
    end

  end # ends "describe "average_revenue" do


  describe "finished_trips" do
    it "returns an array of trips that have an end_time" do
      trips = [
        RideShare::Trip.new({cost: 17.39, rating: 3, start_time: "2016-04-05T14:01:00+00:00", end_time: "2016-04-05T14:09:00+00:00"}),
        RideShare::Trip.new({cost: 17.12, rating: 3, start_time: "2016-01-13T13:16:00+00:00", end_time: "2016-01-13T13:28:00+00:00"}),
        RideShare::Trip.new({cost: 21.88, rating: 3, start_time: "2016-05-02T09:06:00+00:00", end_time: "2016-05-02T09:56:00+00:00"})
      ]
      driver_data = {
        id: 7,
        vin: 'a' * 17,
        name: 'test driver',
        trips: trips
      }
      driver = RideShare::Driver.new(driver_data)
      driver.finished_trips.length.must_equal 2
      trips.last.finish_trip!
      driver.finished_trips.length.must_equal 3
    end # ends "it "returns an array of trips..."

    # it "ignores unfinished trips" do
    #   start_time = Time.parse("2016-02-16T12:45:00+00:00")
    #   trip_data3 = {
    #     id: @id,
    #     driver: @driver,
    #     passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723"),
    #     start_time: start_time, # <-- looks for start_time or a local variable
    #     end_time = nil,
    #     cost: 65,
    #     rating: 3
    #   }
    #   trip = RideShare::Trip.new(trip_data3)
    #   @driver.add_trip(trip)
    #   @driver.average_revenue.must_equal calculatednumberhere
    # end # ends "it "ignores unfinished trips" do

  end # ends "describe "finished_trips" do"

end # ends 'describe "Driver class" do'
