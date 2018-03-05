require_relative 'spec_helper'

# TODO: test is all ride's features are nil ONLY if ride is in progress

TRIP_FEE = 1.65

describe "Driver class" do

  describe "Driver instantiation" do
    # before do
    #   @driver = RideShare::Driver.new(id: 1, name: "George",
    #     vin: "33133313331333133")
    # end

    it "is an instance of Driver" do
      driver = RideShare::Driver.new(id: 1, name: "George",
        vin: "33133313331333133")
      driver.must_be_kind_of RideShare::Driver
    end

    it "throws an argument error with a bad ID value" do
      proc{ RideShare::Driver.new(id: 0, name: "George",
        vin: "33133313331333133") }.must_raise ArgumentError # id = 0

      proc{ RideShare::Driver.new(id: "A", name: "George",
        vin: "33133313331333133") }.must_raise ArgumentError   # id is letter


      proc{ RideShare::Driver.new(name: "George",
        vin: "33133313331333133") }.must_raise ArgumentError # No id
    end

    it "throws an argument error with a bad VIN value" do
      proc{ RideShare::Driver.new(id: 101, name: "George",
        vin: "") }.must_raise ArgumentError  # empty

      proc{ RideShare::Driver.new(id: 101, name: "George",
        vin: "33133313331333133extranums") }.must_raise ArgumentError # too long

      proc{ RideShare::Driver.new(id: 101, name: "George",
        vin: "tooshortbyonechr") }.must_raise ArgumentError  # too short

      proc{ RideShare::Driver.new(id: 101, name: "George",
        vin: ["33133313331333133"]) }.must_raise ArgumentError # wrong type

      proc{ RideShare::Driver.new(id: 101, name: "George") }.must_raise
        ArgumentError # missing
    end

    it "throws an argument error with a bad name value" do
      proc{ RideShare::Driver.new(id: 101, name: "",
        vin: "33133313331333133") }.must_raise ArgumentError # empty String

      proc{ RideShare::Driver.new(id: 101, name: 42,
        vin: "33133313331333133") }.must_raise ArgumentError # wrong type

      proc{ RideShare::Driver.new(id: 101, vin: "33133313331333133")
        }.must_raise ArgumentError # missing
    end

    it "throws an argument error with a bad status value" do
      proc{ RideShare::Driver.new(id: 0, name: "George",
        vin: "33133313331333133") }.must_raise ArgumentError # id = 0

      proc{ RideShare::Driver.new(id: "A", name: "George",
        vin: "33133313331333133") }.must_raise ArgumentError   # id is letter


      proc{ RideShare::Driver.new(name: "George",
        vin: "33133313331333133") }.must_raise ArgumentError # No id
    end

    it "throws an argument error with a bad status value" do
      proc{ RideShare::Driver.new(id: 0, name: "George",
        vin: "33133313331333133") }.must_raise ArgumentError # id = 0

      proc{ RideShare::Driver.new(id: "A", name: "George",
        vin: "33133313331333133") }.must_raise ArgumentError   # id is letter


      proc{ RideShare::Driver.new(name: "George",
        vin: "33133313331333133") }.must_raise ArgumentError # No id
    end

    it "sets status to AVAILABLE if not provided" do
      driver = RideShare::Driver.new(id: 1, name: "George",
        vin: "33133313331333133")

      driver.status.must_equal :AVAILABLE
    end

    it "raises ArgumentError if trips contains an invalid trip" do
      # place_holder_driver is so the Trip objects can be made. Although it does
      # not sense to add it to a different driver, it does not matter for this
      # test.
      place_holder_driver = RideShare::Driver.new(id: 101, name: "Fake",
        vin: "33133313331333139")
      pass = RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640")
      trip = RideShare::Trip.new({id: 8, driver: place_holder_driver,
        passenger: pass, start_time: Time.parse("2018-01-02T10:42:00+00:00")})

      proc{ RideShare::Driver.new(id: 11, name: "George",
        vin: "33133313331333133", trips: [trip, "foo"], status: :UNAVAILABLE)
        }.must_raise ArgumentError

    end

    it "raises ArgumentError if trips contains multiple in-progress trips" do
      # place_holder_driver is so the Trip objects can be made. Although it does
      # not sense to add it to a different driver, it does not matter for this
      # test.
      place_holder_driver = RideShare::Driver.new(id: 101, name: "Fake",
        vin: "33133313331333139")
      pass = RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640")
      trip = RideShare::Trip.new({id: 8, driver: place_holder_driver,
        passenger: pass, start_time: Time.parse("2018-01-02T10:42:00+00:00")})
      trip_two = RideShare::Trip.new({id: 7, driver: place_holder_driver,
        passenger: pass, start_time: Time.parse("2018-01-06T10:42:00+00:00")})

      proc{ RideShare::Driver.new(id: 11, name: "George",
        vin: "33133313331333133", trips: [trip, trip_two], status: :UNAVAILABLE)
        }.must_raise ArgumentError

      proc{ RideShare::Driver.new(id: 11, name: "George",
        vin: "33133313331333133", trips: [trip], status: :AVAILABLE)
        }.must_raise ArgumentError
    end

    it "raises ArgumentError if trips has an in-progress trip but AVAILABLE" do
      # place_holder_driver is so the Trip objects can be made. Although it does
      # not sense to add it to a different driver, it does not matter for this
      # test.
      place_holder_driver = RideShare::Driver.new(id: 101, name: "Fake",
        vin: "33133313331333139")
      pass = RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640")
      trip = RideShare::Trip.new({id: 8, driver: place_holder_driver,
        passenger: pass, start_time: Time.parse("2018-01-02T10:42:00+00:00")})

      proc{ RideShare::Driver.new(id: 11, name: "George",
        vin: "33133313331333133", trips: [trip], status: :AVAILABLE)
        }.must_raise ArgumentError
    end

    it "is set up for specific attributes and data types" do
      driver = RideShare::Driver.new(id: 1, name: "George",
        vin: "33133313331333133")

      [:id, :name, :vehicle_id, :status].each do |prop|
        driver.must_respond_to prop
      end

      driver.id.must_be_kind_of Integer
      driver.name.must_be_kind_of String
      driver.vehicle_id.must_be_kind_of String
      driver.status.must_be_kind_of Symbol
    end
  end

  describe "add trip method" do
    before do
      @pass = RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640")
      @driver = RideShare::Driver.new(id: 3, name: "Lovelace",
        vin: "12345678912345678")
      @trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: @pass,
        start_time: Time.parse("2018-01-02T10:42:00+00:00"),
        end_time: Time.parse("2018-01-02T11:42:00+00:00"), cost: 13.2,
        rating: 5})
    end

    it "throws an argument error if trip is not provided" do
      proc{ @driver.add_trip(1) }.must_raise ArgumentError
    end

    it "increases the trip count by one" do
      test_driver = RideShare::Driver.new(id: 42, name: "Lovelace",
        vin: "12345678912345678", trips: [])
      new_trip = RideShare::Trip.new({id: 8, driver: test_driver,
        passenger: @pass, start_time: Time.parse("2018-01-02T10:42:00+00:00"),
        end_time: Time.parse("2018-01-02T11:42:00+00:00"), cost: 3.2, rating: 5})

      test_driver.add_trip(new_trip)
      test_driver.trips.length.must_equal 1
    end

    it "Does not add a trip if the driver is unavailable" do
      test_driver = RideShare::Driver.new(id: 42, name: "Lovelace",
        vin: "12345678912345678", status: :UNAVAILABLE)

      proc { test_driver.add_trip(RideShare::Trip.new({id: 66,
        driver: test_driver, passenger: @pass, start_time:
        Time.parse("2018-01-02T10:42:00+00:00"), end_time: nil, cost: nil,
        rating: nil})) }.must_raise ArgumentError
    end

    it "sets driver's status to unavailable" do
      test_driver = RideShare::Driver.new(id: 42, name: "Lovelace",
        vin: "12345678912345678", status: :AVAILABLE)
      test_driver.add_trip(RideShare::Trip.new({id: 66,
        driver: test_driver, passenger: @pass, start_time:
        Time.parse("2018-01-02T10:42:00+00:00")}))

      test_driver.status.must_equal :UNAVAILABLE
    end

  end

  describe "get_average_rating method" do
    before do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
        vin: "1C9EVBRM0YBC564DZ")
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III",
        phone: "1-602-620-2330 x3723", trips: [])
      trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: @passenger,
        start_time: Time.parse("2018-01-04T10:42:00+00:00"),
        end_time: Time.parse("2018-01-04T11:42:00+00:00"),  cost: 13.2,
        rating: 5})
      trip2 = RideShare::Trip.new({id: 7, driver: @driver, passenger: @passenger,
        start_time: Time.parse("2018-01-02T10:42:00+00:00"),
        end_time: Time.parse("2018-01-02T11:42:00+00:00"),  cost: 4.88,
        rating: 2})

      @driver.add_trip(trip)
      @driver.add_trip(trip2)
    end

    it "returns a float" do
      @driver.get_average_rating.must_be_kind_of Float
    end

    it "returns a float within range of 1.0 to 5.0" do
      average = @driver.get_average_rating
      average.must_be :>=, 1.0
      average.must_be :<=, 5.0
      average.must_equal 3.5
    end

    it "must not include in-progress trips" do
      rating_before = @driver.get_average_rating
      trip3 = RideShare::Trip.new({id: 7, driver: @driver, passenger: @passenger,
        start_time: Time.parse("2018-01-08T10:42:00+00:00")})
      @driver.add_trip(trip3)
      @driver.get_average_rating.must_equal rating_before
    end

    it "returns zero if no trips" do
      driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
        vin: "1C9EVBRM0YBC564DZ")
      driver.get_average_rating.must_equal 0
    end
  end

  describe "get_total_revenue" do

    before do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III",
        phone: "1-602-620-2330 x3723", trips: [])

      @driver = RideShare::Driver.new(id: 53, name: "Rogers Bartell IV",
        vin: "1C9EVBRM0YBC564DZ",trips: [])

      trip1 = RideShare::Trip.new({id: 3, driver: @driver, passenger: @passenger,
        start_time: Time.parse("2018-01-02T10:40:00+00:00"),
        end_time: Time.parse("2018-01-02T11:00:00+00:00"), cost: 20.45,
        rating: 5})

      trip2 = RideShare::Trip.new({id: 5, driver: @driver, passenger: @passenger,
        start_time: Time.parse("2018-01-04T11:55:00+00:00"),
        end_time: Time.parse("2018-01-04T12:05:00+00:00"), cost: 10.01,
        rating: 4})

      [trip1, trip2].each do |trip|
        @passenger.add_trip(trip)
        @driver.add_trip(trip)
      end

    end

    it "calculates correctly" do
      expected_rev = [20.45, 10.01].inject(0.0) { |sum, cost|
        sum + (cost - TRIP_FEE) * 0.80 }

      @driver.get_total_revenue.must_be_kind_of Float
      @driver.get_total_revenue.must_equal expected_rev
    end

    it "does not include in-progress trips" do
      expected_rev = [20.45, 10.01].inject(0.0) { |sum, cost|
        sum + (cost - TRIP_FEE) * 0.80 }
      new_trip = RideShare::Trip.new({id: 33, driver: @driver, passenger: @passenger,
          start_time: Time.parse("2018-01-08T10:40:00+00:00")})
      @driver.add_trip(new_trip)

      @driver.get_total_revenue.must_equal expected_rev
    end

    it "does not include trips costs below TRIP_FEE" do
      expected_rev = [20.45, 10.01].inject(0.0) { |sum, cost|
        sum + (cost - TRIP_FEE) * 0.80 }
      new_trip = RideShare::Trip.new({id: 33, driver: @driver, passenger: @passenger,
          start_time: Time.parse("2018-01-08T10:40:00"),
          end_time: Time.parse("2018-01-08T11:00:00"), cost: TRIP_FEE - 0.01,
          rating: 5})
      @driver.add_trip(new_trip)

      @driver.get_total_revenue.must_equal expected_rev
    end

    it "updates as trips are added" do
      expected_rev = [20.45, 10.01, (TRIP_FEE + 0.01)].inject(0.0) { |sum, cost|
        sum + (cost - TRIP_FEE) * 0.80 }
      new_trip = RideShare::Trip.new({id: 33, driver: @driver, passenger: @passenger,
          start_time: Time.parse("2018-01-08T10:40:00"),
          end_time: Time.parse("2018-01-08T11:00:00"), cost: TRIP_FEE + 0.01,
          rating: 5})
      @driver.add_trip(new_trip)

      @driver.get_total_revenue.must_equal expected_rev
    end

  end # end describe "get_total_revenue"

  describe "get_avg_revenue_per_hour" do

    before do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III",
        phone: "1-602-620-2330 x3723", trips: [])
      @driver = RideShare::Driver.new(id: 53, name: "Rogers Bartell IV",
        vin: "1C9EVBRM0YBC564DZ",trips: [] )
      trip1 = RideShare::Trip.new({id: 3, driver: @driver, passenger: @passenger,
        start_time: Time.parse("2018-01-02T10:40:00+00:00"),
        end_time: Time.parse("2018-01-02T11:00:00+00:00"), cost: 12.45,
        rating: 5})

      @passenger.add_trip(trip1)
      @driver.add_trip(trip1)

    end

    it 'calculates the average correctly' do
      expected_rev = (12.45 - TRIP_FEE) * 0.80
      expected_duration = @driver.trips.first.get_duration.to_f / 60 / 60
      expected_result = (expected_rev / expected_duration).round(2)

      @driver.get_avg_revenue_per_hour.must_be_kind_of Float
      @driver.get_avg_revenue_per_hour.must_equal expected_result
    end

    it "does not include in-progress trips" do
      expected_rev = (12.45 - TRIP_FEE) * 0.80
      expected_duration = @driver.trips.first.get_duration.to_f / 60 / 60
      expected_result = (expected_rev / expected_duration).round(2)
      new_trip = RideShare::Trip.new({id: 33, driver: @driver, passenger:
        @passenger, start_time: Time.parse("2018-01-08T10:40:00+00:00")})
      @driver.add_trip(new_trip)

      @driver.get_avg_revenue_per_hour.must_equal expected_result
    end

    it "returns 0 for no completed trips" do
      new_driver = RideShare::Driver.new(id: 153, name: "Rogers Bartell IV",
        vin: "1C9EVBRM0YBC564DZ",trips: [] )
      new_trip = RideShare::Trip.new({id: 33, driver: new_driver, passenger:
        @passenger, start_time: Time.parse("2018-01-08T10:40:00+00:00")})
      new_driver.add_trip(new_trip)

      new_driver.get_avg_revenue_per_hour.must_equal 0.0
    end

  end # end describe "get_avg_revenue_per_hour"

  describe "is_available?" do

    it "returns 'true' if the driver's status is ':AVAILABLE'" do
      test_driver = RideShare::Driver.new(id: 3, name: "Lovelace",
        vin: "12345678912345678", status: :AVAILABLE)

      test_driver.is_available?.must_equal true
    end

    it "returns 'false' if the driver's status is ':AVAILABLE'" do
      test_driver = RideShare::Driver.new(id: 3, name: "Lovelace",
        vin: "12345678912345678", status: :UNAVAILABLE)

      test_driver.is_available?.must_equal false

    end


  end

end # end describe driver
