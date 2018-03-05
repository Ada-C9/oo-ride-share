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

  describe "change_status method" do
    it "changes status to unavailable if no status is given when driver is created" do
      driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
      driver.status.must_equal :AVAILABLE
      driver.change_status.must_equal :UNAVAILABLE
    end

    it "changes status to available if initial status is unavailable" do
      driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678", status: :UNAVAILABLE)
      driver.change_status.must_equal :AVAILABLE
    end
  end

  describe "add trip method" do
    before do
      passenger = RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640")
      @driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
      @trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: passenger, start_time: Time.parse("2016-04-05T14:01:00+00:00"), end_time: Time.parse("2016-04-05T14:09:00+00:00"), rating: 5})
    end

    it "raises an argument error if trip is not provided" do
      proc{ @driver.add_trip(1) }.must_raise ArgumentError
    end

    it "increases the trip count by one" do
      previous_count = @driver.trips.length
      @driver.add_trip(@trip)
      @driver.trips.length.must_equal previous_count + 1
    end
  end

  describe "average_rating method" do
    before do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
      trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: nil, start_time: Time.parse("2016-04-05T14:01:00+00:00"), end_time: Time.parse("2016-04-05T14:09:00+00:00"), rating: 5})
      @driver.add_trip(trip)
    end

    it "returns a number" do
      @driver.average_rating.must_be_kind_of Numeric
    end

    it "returns a float within range of 1.0 to 5.0 if driver has completed trips" do
      average = @driver.average_rating
      average.must_be :>=, 1.0
      average.must_be :<=, 5.0
    end

    it "returns zero if driver has no completed trips" do
      driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
      driver.average_rating.must_equal 0
    end
  end

  describe "total_revenue method" do
    before do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
    end

    it "returns a number" do
      @driver.total_revenue.must_be_kind_of Numeric
    end

    it "returns zero if driver has no trips" do
      @driver.total_revenue.must_equal 0
    end

    it "does not deduct the trip fee for trips that cost less than $1.65" do
      passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")
      trip_1 = RideShare::Trip.new({id: 8, driver: @driver, passenger: passenger, start_time: Time.parse("2016-04-05T14:01:00+00:00"), end_time: Time.parse("2016-04-05T14:09:00+00:00"), cost: 1.50, rating: 1})
      @driver.add_trip(trip_1)
      @driver.total_revenue.must_be_within_delta 1.2, 0.01
    end

    it "returns the total revenue for all of the driver's trips" do
      passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")
      trip_1 = RideShare::Trip.new({id: 8, driver: @driver, passenger: passenger, start_time: Time.parse("2016-04-05T14:01:00+00:00"), end_time: Time.parse("2016-04-05T14:09:00+00:00"), cost: 10.00, rating: 3})
      trip_2 = RideShare::Trip.new({id: 8, driver: @driver, passenger: passenger, start_time: Time.parse("2016-01-13T13:16:00+00:00"), end_time: Time.parse("2016-01-13T13:28:00+00:00"), cost: 15.00, rating: 5})
      @driver.add_trip(trip_1)
      @driver.total_revenue.must_be_within_delta 6.68, 0.01
      @driver.add_trip(trip_2)
      @driver.total_revenue.must_be_within_delta 17.36, 0.01
    end
  end

  describe "total_time method" do
    before do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
    end

    it "returns a number" do
      @driver.total_time.must_be_kind_of Numeric
    end

    it "returns zero if driver has no completed trips" do
      @driver.total_time.must_equal 0

      passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")
      trip_1 = RideShare::Trip.new({id: 8, driver: @driver, passenger: passenger, start_time: Time.parse("2016-04-05T14:01:00+00:00"), end_time: nil, cost: nil, rating: nil})
      @driver.add_trip(trip_1)
      @driver.total_time.must_equal 0
    end


    it "returns the sum duration for all of the driver's completed trips" do
      passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")
      trip_1_start = Time.parse("2016-04-05T14:01:00+00:00")
      trip_1_end = trip_1_start + 8 * 60  #8 minutes later
      trip_1 = RideShare::Trip.new({id: 8, driver: @driver, passenger: passenger, start_time: trip_1_start, end_time: trip_1_end, cost: 10.00, rating: 3})
      trip_2_start = Time.parse("2016-01-13T13:16:00+00:00")
      trip_2_end = trip_2_start + 12 * 60   #12 minutes later
      trip_2 = RideShare::Trip.new({id: 8, driver: @driver, passenger: passenger, start_time: trip_2_start, end_time: trip_2_end, cost: 15.00, rating: 5})

      @driver.add_trip(trip_1)
      @driver.total_time.must_equal 480

      @driver.add_trip(trip_2)
      @driver.total_time.must_equal 1200
    end
  end

  describe "revenue_per_hour method" do
    before do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
    end

    it "returns a number" do
      @driver.must_respond_to :revenue_per_hour
      @driver.revenue_per_hour.must_be_kind_of Numeric
    end

    it "returns zero if driver has no trips" do
      @driver.revenue_per_hour.must_equal 0
    end

    it "returns zero if driver's total trip durations are zero" do
      passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")
      trip_1 = RideShare::Trip.new({id: 8, driver: @driver, passenger: passenger, start_time: Time.parse("2016-04-05T14:01:00+00:00"), end_time: Time.parse("2016-04-05T14:01:00+00:00"), cost: 10.00, rating: 3})
      @driver.add_trip(trip_1)
      @driver.revenue_per_hour.must_equal 0
    end

    it "returns the average revenue per hour for the driver's trips" do
      passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")
      trip_1 = RideShare::Trip.new({id: 8, driver: @driver, passenger: passenger, start_time: Time.parse("2016-04-05T14:01:00+00:00"), end_time: Time.parse("2016-04-05T14:09:00+00:00"), cost: 10.00, rating: 3})
      trip_2 = RideShare::Trip.new({id: 8, driver: @driver, passenger: passenger, start_time: Time.parse("2016-01-13T13:16:00+00:00"), end_time: Time.parse("2016-01-13T13:28:00+00:00"), cost: 15.00, rating: 5})
      @driver.add_trip(trip_1)
      @driver.revenue_per_hour.must_be_within_delta 50.1, 0.01
      @driver.add_trip(trip_2)
      @driver.revenue_per_hour.must_be_within_delta 52.08, 0.01
    end
  end

  describe "completed_trips method" do
    before do
      @dispatcher = RideShare::TripDispatcher.new
      @driver_14 = @dispatcher.find_driver(14)
    end

    it "returns an array of trips" do
      @driver_14.completed_trips.must_be_kind_of Array
      @driver_14.completed_trips.each do |trip|
        trip.must_be_instance_of RideShare::Trip
      end
    end

    # TODO: come back to this after you've fixed trip assignment
    it "does not include incomplete trips" do
      new_trip = @dispatcher.request_trip(1)
      @driver_14.trips.must_include new_trip
      @driver_14.completed_trips.wont_include new_trip
    end

    it "returns an empty array if the driver has no trips" do
      new_driver = RideShare::Driver.new(id: 101, name: "Caroline Nardi", vin: "1C9EVBRM0YBC564DZ")
      new_driver.completed_trips.must_be_kind_of Array
      new_driver.completed_trips.must_be_empty
    end
  end
end
