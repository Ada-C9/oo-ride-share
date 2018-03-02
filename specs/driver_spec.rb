require_relative 'spec_helper'
require 'time'

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
      @trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: pass, start_time: Time.parse('2015-05-20T12:14:00+00:00'), end_time: Time.parse('2015-05-20T12:25:00+00:00'), rating: 5})
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
      trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: nil, start_time: Time.parse('2015-05-20T12:14:00+00:00'), end_time: Time.parse('2015-05-20T12:25:00+00:00'), rating: 5})
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
  end # describe Driver#average_rating

  describe "total_revenue and average_revenue methods" do
    before do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")

      @trip_one = RideShare::Trip.new({id: 1, driver: @driver, passenger: nil, start_time: Time.parse('2015-05-20T12:14:00+00:00'), end_time: Time.parse('2015-05-20T12:25:00+00:00'), cost: 5.98, rating: 5})

      @trip_two = RideShare::Trip.new({id: 2, driver: @driver, passenger: nil, start_time: Time.parse('2015-05-20T12:14:00+00:00'), end_time: Time.parse('2015-05-20T12:25:00+00:00'), cost: 19.52, rating: 5})

      @trip_three = RideShare::Trip.new({id: 3, driver: @driver, passenger: nil, start_time: Time.parse('2015-05-20T12:14:00+00:00'), end_time: Time.parse('2015-05-20T12:25:00+00:00'), cost: 9.86, rating: 5})
      @driver.add_trip(@trip_one)
      @driver.add_trip(@trip_two)
      @driver.add_trip(@trip_three)
    end

    describe "total_revenue method" do
      it "returns a float" do
        @driver.total_revenue.must_be_kind_of Float
      end

      it "returns a float greater than or equal to 0.00" do
        result = @driver.total_revenue
        result.must_be :>=, 0.00
      end

      it "returns zero if no trips" do
        driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
        driver.total_revenue.must_equal 0.00
      end

      it "returns the sum of the cost of each of the driver's trips" do
        total_revenue = @trip_one.cost + @trip_two.cost + @trip_three.cost - 1.65 * 3
        total_revenue *= 0.80

        result = @driver.total_revenue
        result.must_equal total_revenue
      end
    end # describe total_revenue method

    describe "average_revenue method" do

      it "returns a float" do
        @driver.average_revenue.must_be_kind_of Float
      end

      it "returns a float greater than or equal to 0.00" do
        result = @driver.average_revenue
        result.must_be :>=, 0.00
      end

      it "returns zero if no trips" do
        driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
        driver.average_revenue.must_equal 0
      end

      it "returns the sum of the cost of each of the driver's trips" do
        total_duration_in_seconds = @trip_one.duration + @trip_two.duration + @trip_three.duration

        total_duration_in_hours = total_duration_in_seconds

        total_revenue = @trip_one.cost + @trip_two.cost + @trip_three.cost - 1.65 * 3

        total_revenue *= 0.80

        average_revenue = total_revenue / total_duration_in_hours

        result = @driver.average_revenue
        result.must_equal average_revenue.round(2)
      end

    end # describe average_revenue method

  end # describe total_revenue and average_revenue ratings 

end # describe Driver
