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
      # proc{ RideShare::Driver.new(id: 0, name: "George", vin: "33133313331333133")}.must_raise ArgumentError
      # write the test with begin and rescue instead of proc
      begin
        RideShare::Driver.new(id: 0, name: "George", vin: "33133313331333133")
        # this is where you would put what doesn't pass and will fail
        fail
      rescue ArgumentError
        pass
      end
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
  end # end of describe "Driver instantiation"

  describe "add trip method" do
    before do
      pass = RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640")
      @driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
      @trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: pass, start_time: "2016-08-08", end_time: "2016-08-08T12:14:00+00:00", rating: 5})
    end

    it "throws an argument error if trip is not provided" do
      proc{ @driver.add_trip(1) }.must_raise ArgumentError
    end

    it "increases the trip count by one" do
      previous = @driver.trips.length
      @driver.add_trip(@trip)
      @driver.trips.length.must_equal previous + 1
    end
  end # end of describe "add trip method"

  describe "average_rating method" do
    before do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
      trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: nil, start_time: "2016-08-08", end_time: "2016-08-08T12:14:00+00:00", rating: 5})
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
  end # end of describe "average_rating method"

  describe "total_revenue method" do
    it "calculate the total revenue" do
      trips = [
        RideShare::Trip.new({start_time: "2016-08-08", end_time: "2016-08-08T12:14:00+00:00", cost: 5, rating: 3}),
        RideShare::Trip.new({start_time: "2016-08-08", end_time: "2016-08-08T12:14:00+00:00", cost: 7, rating: 3}),
        RideShare::Trip.new({start_time: "2016-08-08", end_time: "2016-08-08T12:14:00+00:00", cost: 8, rating: 3}),
      ]

      driver_data = {
        id: 7,
        name: "test driver",
        vin: "1C9EVBRM0YBC564DZ",
        trips: trips
      }

      driver = RideShare::Driver.new(driver_data)

      driver.total_revenue.must_equal 12.04
    end
  end # end of describe "total_revenue method"

  describe "average_revenue method" do
    before do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 60 * 60
      trip_data = {
        id: 8,
        driver: nil,
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: start_time,
        end_time: end_time,
        cost: 20.00,
        rating: 3
      }
      trip_data2 = {
        id: 10,
        driver: nil,
        passenger: RideShare::Passenger.new(id: 21, name: "Lovelace", phone: "412-867-5309"),
        start_time: start_time,
        end_time: end_time,
        cost: 10.00,
        rating: 5
      }
      trip = RideShare::Trip.new(trip_data)
      trip2 = RideShare::Trip.new(trip_data2)
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
      @driver.add_trip(trip)
      @driver.add_trip(trip2)
    end

    it "calculate the average revenue per hour" do
      @driver.average_revenue.must_equal 42.72
    end
  end # end of describe "average_revenue method"

  describe "finish_trip" do
    before do
      trip_data = {
        id: 8,
        driver: nil,
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: Time.parse('2015-05-20T12:14:00+00:00'),
        end_time: nil,
        cost: 20.00,
        rating: 3
      }
      trip_data2 = {
        id: 10,
        driver: nil,
        passenger: RideShare::Passenger.new(id: 21, name: "Lovelace", phone: "412-867-5309"),
        start_time: Time.parse('2015-05-20T12:14:00+00:00'),
        end_time: Time.parse('2015-05-20T13:14:00+00:00'),
        cost: 10.00,
        rating: 5
      }
      @trip = RideShare::Trip.new(trip_data)
      @trip2 = RideShare::Trip.new(trip_data2)
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
      @driver.add_trip(@trip)
      @driver.add_trip(@trip2)
    end

    it "remove trip from trips if end time is nil" do
      @driver.finish_trip.must_include @trip2
      @driver.finish_trip.wont_include @trip
    end
  end # end of describe "finish_trip"
end # end of describe "Driver class"
