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

  describe "add_trip(trip) method" do
    before do
      pass = RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640")
      @driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
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
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: pass, start_time: start_time, end_time: end_time, rating: 5})
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

  describe "get_revenue method" do
    before do
      @driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
    end

    it "calculates revenue with one trip" do
      trip = RideShare::Trip.new({id: 1, driver: @driver, passenger: pass, cost: 15.00, rating: 5})
      @driver.add_trip(trip)
      @driver.get_revenue.must_equal 10.68
    end

    it "calculates revenue with trip in progress" do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')

      trip = RideShare::Trip.new({id: 1, driver: @driver, passenger: pass, rating: 5, start_time: start_time})

      @driver.add_trip(trip)
      @driver.get_revenue.must_equal 0
    end

    it "calculates revenue with multiple trips" do
      trip = RideShare::Trip.new({id: 1, driver: @driver, passenger: pass, cost: 15.25, rating: 5})
      @driver.add_trip(trip)

      trip = RideShare::Trip.new({id: 1, driver: @driver, passenger: pass, cost: 35.03, rating: 5})
      @driver.add_trip(trip)

      trip = RideShare::Trip.new({id: 1, driver: @driver, passenger: pass, cost: 55.15, rating: 5})
      @driver.add_trip(trip)

      @driver.get_revenue.must_equal 80.38
    end

    it "returns zero where there are no trips" do
      @driver.get_revenue.must_equal 0
    end

    it "returns zero if fee is greater than or equal to cost" do
      trip = RideShare::Trip.new({id: 1, driver: @driver, passenger: pass, cost: 1.00, rating: 5})
      @driver.add_trip(trip)
      @driver.get_revenue.must_equal 0
    end
  end

  describe "get_revenue_per_hour method" do
    before do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      @trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: pass, start_time: start_time, end_time: end_time, cost: 15.00, rating: 5})
    end

    it "returns zero when no trips" do
      @driver.get_revenue_per_hour.must_equal 0
    end

    it "calculates revenue per hour with one trip" do
      @driver.add_trip(@trip)

      @driver.get_revenue_per_hour.must_equal 25.63
    end

    it "calculates revenue per hour with many trips" do
      10.times { @driver.add_trip(@trip) }
      @driver.get_revenue_per_hour.must_equal 25.63
    end
  end

  describe "drivers_most_recent_trip method" do
    before do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ", status: :AVAILABLE)
    end

    it "provides drivers_most_recent_trip with one trip" do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: pass, start_time: start_time, end_time: end_time, cost: 15.00, rating: 5})
      @driver.add_trip(trip)

      @driver.drivers_most_recent_trip.must_equal trip
    end

    it "provides drivers_most_recent_trip with multiple trips" do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      trip_one = RideShare::Trip.new({id: 8, driver: @driver, passenger: pass, start_time: start_time, end_time: end_time, cost: 15.00, rating: 5})
      @driver.add_trip(trip_one)

      start_time = Time.parse('2017-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      trip_two = RideShare::Trip.new({id: 8, driver: @driver, passenger: pass, start_time: start_time, end_time: end_time, cost: 15.00, rating: 5})
      @driver.add_trip(trip_two)

      @driver.drivers_most_recent_trip.must_equal trip_two
    end
  end

  describe "available? method" do
    before do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ", status: :AVAILABLE)
    end

    it "returns true if driver available" do
      @driver.available?.must_equal true
    end
  end

  describe "accept_trip method and make_driver_unavailable method" do
    before do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ", status: :AVAILABLE)
    end

    it "make_driver_unavailable changes driver's status to unavailable" do
      @driver.status.must_equal :AVAILABLE
      @driver.make_driver_unavailable
      @driver.status.must_equal :UNAVAILABLE
    end

    it "accept_trip changes driver's status to unavailable" do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: pass, start_time: start_time, end_time: end_time, cost: 15.00, rating: 5})

      @driver.accept_trip(trip)
      @driver.status.must_equal :UNAVAILABLE
    end

    it "accept_trip adds the trip to the driver's trip array" do
      @driver.trips.empty?.must_equal true

      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: pass, start_time: start_time, end_time: end_time, cost: 15.00, rating: 5})

      @driver.accept_trip(trip)
      @driver.trips.wont_be_nil
    end
  end

  describe "on_trip_now? method" do
    before do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ", status: :AVAILABLE)
    end

    it "returns false if no trips recorded" do
      @driver.on_trip_now?.must_equal false
    end

    it "returns false if multiple trips and all are completed" do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: pass, start_time: start_time, end_time: end_time, cost: 15.00, rating: 5})
      5.times {@driver.add_trip(trip)}

      @driver.on_trip_now?.must_equal false
    end

    it "returns true if multiple trip one is in progress" do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: pass, start_time: start_time, end_time: end_time, cost: 15.00, rating: 5})
      5.times {@driver.add_trip(trip)}

      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: pass, start_time: start_time, cost: 15.00, rating: 5})
      @driver.add_trip(trip)

      @driver.on_trip_now?.must_equal true
    end
  end

end
