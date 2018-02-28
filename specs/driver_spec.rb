require_relative 'spec_helper'

describe "Driver class" do

  describe "Driver instantiation" do
    before do
      @driver = RideShare::Driver.new(id: 1, name: "George",
        vin: "33133313331333133")
    end

    it "is an instance of Driver" do
      @driver.must_be_kind_of RideShare::Driver
    end

    it "throws an argument error with a bad ID value" do
      proc{ RideShare::Driver.new(id: 0, name: "George",
        vin: "33133313331333133")}.must_raise ArgumentError
    end

    it "throws an argument error with a bad VIN value" do
      proc{ RideShare::Driver.new(id: 100, name: "George",
        vin: "")}.must_raise ArgumentError
      proc{ RideShare::Driver.new(id: 100, name: "George",
        vin: "33133313331333133extranums")}.must_raise ArgumentError
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
      @driver = RideShare::Driver.new(id: 3, name: "Lovelace",
        vin: "12345678912345678")
      @trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: pass,
        start_time: Time.parse("2018-01-02T10:42:00+00:00"),
        end_time: Time.parse("2018-01-02T11:42:00+00:00"),
        rating: 5})
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
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
        vin: "1C9EVBRM0YBC564DZ")
      trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: nil,
        start_time: Time.parse("2018-01-02T10:42:00+00:00"),
        end_time: Time.parse("2018-01-02T11:42:00+00:00"),
        rating: 5})
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
      driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
        vin: "1C9EVBRM0YBC564DZ")
      driver.average_rating.must_equal 0
    end
  end

  describe "get_total_revenue" do

    before do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III",
        phone: "1-602-620-2330 x3723", trips: [])

      @driver = RideShare::Driver.new(id: 53, name: "Rogers Bartell IV",
        vin: "1C9EVBRM0YBC564DZ",trips: [] )

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

    it 'calculates correctly' do
      expected_rev = [20.45, 10.01].inject(0.0) { |sum, cost| sum + (cost - 1.56) * 0.80 }
      @driver.get_total_revenue.must_be_kind_of Float
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

      # trip2 = RideShare::Trip.new({id: 5, driver: @driver, passenger: @passenger,
      #   start_time: Time.parse("2018-01-04T10:55:00+00:00"),
      #   end_time: Time.parse("2018-01-04T11:25:00+00:00"), cost: 10.01,
      #   rating: 4})
    end

    it 'calculates the average correctly' do

      expected_rev = (12.45 - 1.56) * 0.80
      expected_duration = @driver.trips.first.get_duration.to_f / 120
      @driver.get_avg_revenue_per_hour.must_be_kind_of Float
      @driver.get_avg_revenue_per_hour.must_equal (expected_rev / expected_duration).round(2)
    end
  end # end describe "get_avg_revenue_per_hour"


end # end describe driver
