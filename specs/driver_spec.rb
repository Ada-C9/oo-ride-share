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
      start_time = Time.parse("2016-08-08T16:01:00+00:00")
      end_time = start_time + 60 * 60 # + 1 hour
      pass = RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640")
      @driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
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
      start_time = Time.parse("2016-08-08T16:01:00+00:00")
      end_time = start_time + 60 * 60 # + 1 hour

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
      driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
      driver.average_rating.must_equal 0
    end
  end

  describe '#total_rev' do
    it 'Calculates that driver total revenue across all their trips.' do
      start_time = Time.parse("2016-08-08T16:01:00+00:00")
      end_time = start_time + 60 * 60 # + 1 hour

      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")

      trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: nil, start_time: start_time, end_time: end_time, rating: 5, cost: 10})

      @driver.add_trip(trip)

      cost = (10 - 1.65) * 0.8

      @driver.total_rev.must_equal cost
    end
  end

  describe '#average_revenue' do
    it 'Calculates that driver average revenue per hour spent driving' do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")

      start_time = Time.parse("2016-08-08T16:01:00+00:00")
      end_time = start_time + 60 * 60 # + 1 hour

      trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: nil, start_time: start_time, end_time: end_time, rating: 5, cost: 10})

      @driver.add_trip(trip)

      total_hours = (end_time.to_i - start_time.to_i)/3600
      total_rev = (10 - 1.65) * 0.8
      average_rev = total_rev / total_hours
      @driver.average_revenue.must_equal average_rev
    end

    it 'Ignores the trips that are still in progress' do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")

      start_time = Time.parse("2016-08-08T16:01:00+00:00")
      end_time = nil

      trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: nil, start_time: start_time, end_time: end_time, rating: 5, cost: 10})

      @driver.add_trip(trip)

      @driver.average_revenue.must_equal 0
    end
  end
end
