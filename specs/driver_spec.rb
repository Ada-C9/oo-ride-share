require 'time'
require_relative 'spec_helper'

describe "Driver class" do

  before do

  @driver_a = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")

  pass_a = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")

  trip_1 = RideShare::Trip.new({id: 8, driver: @driver_a, passenger: pass_a, start_time: Time.parse('2016-08-08T16:01:00+00:00'), end_time: Time.parse('2016-08-08T16:37:00+00:00'), cost: 10.12, rating: 5})

  trip_2 = RideShare::Trip.new({id: 9, driver: @driver_a, passenger: pass_a, start_time: Time.parse('2016-09-08T16:01:00+00:00'), end_time: Time.parse('2016-09-08T16:38:00+00:00'), cost: 10.13, rating: 5})

  trip_3 = RideShare::Trip.new({id: 10, driver: @driver_a, passenger: pass_a, start_time: Time.parse('2016-10-08T16:01:00+00:00'), end_time: Time.parse('2016-10-08T16:39:00+00:00'), cost: 10.14, rating: 5})

  @driver_a.add_trip(trip_1)
  @driver_a.add_trip(trip_2)
  @driver_a.add_trip(trip_3)

  @trip_now_ongoing = RideShare::Trip.new({id: 801, driver: "driver_TBD", passenger: "passenger_TBD", start_time: Time.now, end_time: nil, cost: nil, rating: nil})

  end

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
      @trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: pass, start_date: Time.parse('2016-08-08T16:01:00+00:00'), end_date: Time.parse('2016-08-08T16:37:00+00:00'), cost: 10.12, rating: 5})
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

  describe "accept_new_trip_assignment(trip)" do
    before do
        @assigned_trip = RideShare::Trip.new({id: 700, driver: @driver_a, passenger: "Unica Zurn", start_time: Time.now, end_time: nil, cost: nil, rating: nil})

        @driver_a.accept_new_trip_assignment(@assigned_trip)
    end

    it "adds the specified trip to the driver's collection" do
        @driver_a.trips.must_include @assigned_trip
        @driver_a.trips.count.must_equal 4
    end

    it "changes the driver's status to UNAVAILABLE" do
      @driver_a.status.must_equal :UNAVAILABLE
    end
  end

  describe "average_rating method" do
    before do

      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")

      trip_a = RideShare::Trip.new({id: 8, driver: @driver, passenger: nil, start_date: Time.parse('2016-08-08T16:01:00+00:00'), end_date: Time.parse('2016-08-08T16:37:00+00:00'), cost: 10.12, rating: 5})

      trip_b = RideShare::Trip.new({id: 901, driver: @driver, passenger: "somebody", start_date: Time.parse('2016-06-08T16:01:00+00:00'), end_date: Time.parse('2016-06-08T16:37:00+00:00'), cost: 10.12, rating: 2})

      @driver.add_trip(trip_a)
      @driver.add_trip(trip_b)

    end

    it "returns a float" do
      @driver.average_rating.must_be_kind_of Float
    end

    it "returns a float within range of 1.0 to 5.0" do
      average = @driver.average_rating
      average.must_be :>=, 1.0
      average.must_be :<=, 5.0
    end

    it "correctly averages the driver's ratings" do
      two_trip_average = @driver.average_rating
      two_trip_average.must_be_within_delta 3.5, 0.003
    end

    it "returns zero if no trips" do
      driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
      driver.average_rating.must_equal 0
    end

    it "behaves properly even if one of the driver's trips is not yet complete" do
      #Testing for float output
      @driver.add_trip(@trip_now_ongoing)
      @driver.average_rating.must_be_kind_of Float

      #Testing for average rating within range
      average_with_ongoing = @driver.average_rating
      average_with_ongoing.must_be :>=, 1.0
      average_with_ongoing.must_be :<=, 5.0

      #Testing for hard-coded expactation
      average_with_ongoing.must_be_within_delta 3.5, 0.003
    end
  end

  describe "total_revenue" do

    it "returns an accurate report of the driver's total revenue" do

      driver_total_take_home = @driver_a.total_revenue
      driver_total_take_home.must_be_within_delta 20.35, 0.003

    end

    it "functions properly when the driver has a trip in progress" do

      @driver_a.add_trip(@trip_now_ongoing)
      @driver_a.total_revenue.must_be_within_delta 20.35, 0.003

    end

    it "returns a total revenue figure that represents 80% of the total recieved by the driver, after deduction of $1.65 per trip" do

    # This is kind of a goofy test, I know, because a lot of what it does
    # is test itself.  But I think it still makes sense as a test of this method,
    # because it shows the steps by which we arrive at the
    # figure in the previous test.

    # It's sort of a proof-of-concept for the calculation in the method, and it
    # would allow a non-technical person to easily see what was going on.

      total_trips = @driver_a.trips.count
      fees_deducted = 1.65 * total_trips

      per_trip_gross = []
      @driver_a.trips.each do |trips|
        trip_cost = trips.cost
        per_trip_gross << trip_cost
      end

      overall_gross = per_trip_gross.sum

      total_trips.must_equal 3
      fees_deducted.must_be_within_delta 4.95, 0.003
      per_trip_gross.length.must_equal 3
      overall_gross.must_be_within_delta 30.39, 0.003

      overall_gross_less_fees = overall_gross - fees_deducted
      overall_gross_less_fees.must_be_within_delta 25.44, 0.003
      overall_driver_revenue = overall_gross_less_fees * 0.8

      @driver_a.total_revenue.must_be_within_delta overall_driver_revenue, 0.003

    end
  end

  describe "average_revenue" do
    it "accurately returns a given driver's average per-trip take-home revenue" do

      @driver_a.total_revenue

      @driver_a.average_revenue.must_be_within_delta 6.78, 0.003

    end
  end
end
