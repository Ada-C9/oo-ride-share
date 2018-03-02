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

      @trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: pass, start_time: Time.parse("2016-04-05T14:01:00+00:00"), end_time: Time.parse("2016-04-05T14:09:00+00:00"), rating: 5})
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
      trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: nil, start_time: Time.parse("2016-04-05T14:01:00+00:00"), end_time: Time.parse("2016-04-05T14:09:00+00:00"), rating: 5})
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

  describe "total_revenue method" do
    # Arrange ------------------
    before do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")

      passenger = 1

      trip_1 = RideShare::Trip.new({id: 8, driver: @driver, passenger: passenger, start_time: Time.parse("2016-04-05T14:01:00+00:00"), end_time: Time.parse("2016-04-05T14:09:00+00:00"), cost: 23.10, rating: 5})
      @driver.add_trip(trip_1)
    end

    it "can sum up more then one trip" do
      passenger_1 = 2
      passenger_2 = 3
      # Arrange------------------------
      trip_2 = RideShare::Trip.new({id: 8, driver: @driver, passenger: passenger_1, start_time: Time.parse("2016-04-05T14:01:00+00:00"), end_time: Time.parse("2016-04-05T14:09:00+00:00"), cost: 23.10, rating: 5})
      @driver.add_trip(trip_2)

      trip_3 = RideShare::Trip.new({id: 8, driver: @driver, passenger: passenger_2, start_time: Time.parse("2016-04-05T14:01:00+00:00"), end_time: Time.parse("2016-04-05T14:09:00+00:00"), cost: 23.10, rating: 5})
      @driver.add_trip(trip_3)

      # Act--------Assert
      number_o_trips = 3
      price = 23.10
      fee = 1.65
      driver_take_home = 0.8
      expected_total = (price - fee) * number_o_trips * driver_take_home

      @driver.total_revenue.must_be_within_delta expected_total # this includes all associated fees and percentage
    end

    it "returns an error if the cost is less then the fee" do
      proc {
        passenger = 1
        # Arrange --------------
        test_trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: passenger, start_time: Time.parse("2016-04-05T14:01:00+00:00"), end_time: Time.parse("2016-04-05T14:09:00+00:00"), cost: 1.00, rating: 5})

        @driver.add_trip(test_trip)

        @driver.total_revenue.must_raise ArgumentError}
      end
    end
  end

  describe "av_revenue_hr method" do
    before do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")

      passenger_1 = 1
      passenger_2 = 2
      passenger_3 = 3

      trip_1 = RideShare::Trip.new({id: 8, driver: @driver, passenger: passenger_1, start_time: Time.parse("2016-04-05T14:00:00+00:00"), end_time: Time.parse("2016-04-05T15:00:00+00:00"), cost: 23.10, rating: 5})
      @driver.add_trip(trip_1)

      # Arrange------------------------
      trip_2 = RideShare::Trip.new({id: 8, driver: @driver, passenger: passenger_2, start_time: Time.parse("2016-04-05T14:00:00+00:00"), end_time: Time.parse("2016-04-05T15:00:00+00:00"), cost: 23.10, rating: 5})
      @driver.add_trip(trip_2)

      trip_3 = RideShare::Trip.new({id: 8, driver: @driver, passenger: passenger_3, start_time: Time.parse("2016-04-05T14:00:00+00:00"), end_time: Time.parse("2016-04-05T15:00:00+00:00"), cost: 23.10, rating: 5})
      @driver.add_trip(trip_3)
    end
    # **W1: TEST TO INSTITUE AVERAGE REVENUE PER HOUR METHOD-----------
    it "is able to calculate the average revenue" do
      number_o_trips = 3
      price = 23.10
      fee = 1.65
      driver_take_home = 0.8
      expected_total = (price - fee) * number_o_trips * driver_take_home
      total_driving_hours = 3

      av_revenue_hour = (expected_total/total_driving_hours)

      @driver.av_revenue_hr.must_be_within_delta av_revenue_hour
      # **W1: TEST TO INSTITUE AVERAGE REVENUE PER HOUR METHOD-----------
    end
  end

  # ** W2: TESTS FOR UPDATE DRIVER METHOD------
  describe "update_driver method" do
    before do
      @driver = RideShare::Driver.new ({id: 14, name: "Antwan Prosacco", vin: "KPLUTG0L6NW1A0ZRF", status: :AVAILABLE, trips: []})

      @unavailable_driver = RideShare::Driver.new ({id: 14, name: "Antwan Prosacco", vin: "KPLUTG0L6NW1A0ZRF", status: :UNAVAILABLE, trips: []})

      trip_data = {
        id: 8,
        driver: @driver,
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: Time.now,
        end_time: nil,
        cost: 23.45,
        rating: 3
      }
      @test_trip = RideShare::Trip.new(trip_data)
    end

    it " is able to add the requested trip to total trip" do
      total_trips =  @driver.trips.length
      @driver.update_driver(@test_trip)
      @driver.trips.length.must_equal total_trips + 1
    end

    it "updates driver status" do
      @driver.update_driver(@test_trip)
      @driver.status.must_equal :UNAVAILABLE
    end

    it "throws an error if driver assigned had an UNAVAILABLE status" do
      proc{
        @unavailable_driver.update_driver(@test_trip)
      }.must_raise ArgumentError
    end
  end
