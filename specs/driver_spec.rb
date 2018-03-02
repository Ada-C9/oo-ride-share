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

      trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: nil, start_time: start_time, end_time: end_time, rating: 5})
      @driver.add_trip(trip)

      second_trip = RideShare::Trip.new({id: 9, driver: @driver, passenger: nil, start_time: start_time, end_time: end_time, rating: 3})
      @driver.add_trip(second_trip)
    end

    it "returns a float" do
      @driver.average_rating.must_be_kind_of Float
    end

    it "returns a float within range of 1.0 to 5.0" do
      average = @driver.average_rating
      average.must_be :>=, 1.0
      average.must_be :<=, 5.0
      average.must_equal 4.0
    end

    it "returns zero if no trips" do
      driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
      driver.average_rating.must_equal 0
    end

    it "does not include the nil rating of a trip in progress" do
      in_progress_trip_data = {
        id: 10,
        driver: @driver,
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil,
      }

      in_progress_trip = RideShare::Trip.new(in_progress_trip_data)

      @driver.add_trip(in_progress_trip)

      @driver.average_rating.must_equal 4.0

    end
  end

  describe "total_revenue method" do

    before do
      @passenger = RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640")

      @driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")

      @start_time = Time.parse('2015-05-20T12:14:00+00:00')
      @end_time = @start_time + 25 * 60 # 25 minutes

      @first_trip_data = {
        id: 8,
        driver: @driver,
        passenger: @passenger,
        start_time: @start_time,
        end_time: @end_time,
        cost: 100,
        rating: 3
      }
      @second_trip_data = {
        id: 9,
        driver: @driver,
        passenger: @passenger,
        start_time: @start_time,
        end_time: @end_time,
        cost: 100,
        rating: 5
      }

      @driver.add_trip(RideShare::Trip.new(@first_trip_data))
      @driver.add_trip(RideShare::Trip.new(@second_trip_data))

    end

    it "returns drivers total revenue" do
      @driver.total_revenue.must_equal 157.36
    end

    it "returns drivers total revenue even if they have a trip in progress" do
      in_progress_trip = {
        id: 10,
        driver: @driver,
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil,
      }

    @driver.add_trip(RideShare::Trip.new(in_progress_trip))

    @driver.total_revenue.must_equal 157.36
    @driver.trips.length.must_equal 3

    end
  end

  describe "average revenue per hour method" do
    before do
      @passenger = RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640")

      @driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")

      @start_time = Time.parse('2015-05-20T12:14:00+00:00')
      @end_time = @start_time + 60 * 60 # 1 hour

      @first_trip_data = {
        id: 8,
        driver: @driver,
        passenger: @passenger,
        start_time: @start_time,
        end_time: @end_time,
        cost: 50,
        rating: 3
      }
      @second_trip_data = {
        id: 9,
        driver: @driver,
        passenger: @passenger,
        start_time: @start_time,
        end_time: @end_time,
        cost: 100,
        rating: 5
      }

      @driver.add_trip(RideShare::Trip.new(@first_trip_data))
      @driver.add_trip(RideShare::Trip.new(@second_trip_data))
    end

    it "calculates driver's average revenue per hour spent driving" do

      @driver.total_revenue_per_hour.must_equal 58.68

    end

    it "excludes the nil cost of a trip that is currently in progress, does not affect total rev per hour" do
      in_progress_trip_data = {
        id: 10,
        driver: @driver,
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil,
      }

      in_progress_trip = RideShare::Trip.new(in_progress_trip_data)

      @driver.add_trip(in_progress_trip)

      @driver.total_revenue_per_hour.must_equal 58.68

    end


  end

end
