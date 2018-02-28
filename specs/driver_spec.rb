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
      @trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: pass, start_time: "2016-08-08", rating: 5})
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
      trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: nil, start_time: "2016-08-08", rating: 5})
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
    it "returns total revenue of a driver" do
      driver_data = {id: 3, name: "Lovelace", vin: "12345678912345678"}
      driver = RideShare::Driver.new(driver_data)

      start_time_1 = Time.parse('2015-05-20T12:14:00+00:00')
      end_time_1 = start_time_1 + 40 * 60
      trip_1 = {
        id: 8,
        driver: driver,
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: start_time_1,
        end_time: end_time_1,
        cost: 50.45,
        rating: 4
      }

      start_time_2 = Time.parse('2015-07-20T12:14:00+00:00')
      end_time_2 = start_time_2 + 20 * 60
      trip_2 = {
        id: 9,
        driver: driver,
        passenger: RideShare::Passenger.new(id: 4, name: "Ada", phone: "412-432-7640"),
        start_time: start_time_2,
        end_time: end_time_2,
        cost: 23.45,
        rating: 3
      }

      start_time_3 = Time.parse('2015-09-20T12:14:00+00:00')
      end_time_3 = start_time_3 + 90 * 60
      trip_3 = {
        id: 10,
        driver: driver,
        passenger: RideShare::Passenger.new(id: 5, name: "Wenjie", phone: "206-432-7640"),
        start_time: start_time_3,
        end_time: end_time_3,
        cost: 99.45,
        rating: 5
      }

      trips = [
        RideShare::Trip.new(trip_1),
        RideShare::Trip.new(trip_2),
        RideShare::Trip.new(trip_3)
      ]

      trips.each do |trip|
        driver.add_trip(trip)
      end

      driver.total_revenue.must_equal 134.72
    end

    it "raises an StandardError when total revenue is negative" do
      driver_data = {id: 3, name: "Lovelace", vin: "12345678912345678"}
      driver = RideShare::Driver.new(driver_data)

      start_time_1 = Time.parse('2015-05-20T12:14:00+00:00')
      end_time_1 = start_time_1 + 2 * 60
      trip_1 = {
        id: 8,
        driver: driver,
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: start_time_1,
        end_time: end_time_1,
        cost: 1.5,
        rating: 4
      }

      driver.add_trip(RideShare::Trip.new(trip_1))
      proc { driver.total_revenue }.must_raise StandardError
    end
  end

  describe "average_revenue method" do
    it "returns average revenue per hour by a driver" do
      driver_data = {id: 3, name: "Lovelace", vin: "12345678912345678"}
      driver = RideShare::Driver.new(driver_data)


      start_time_1 = Time.parse('2015-05-20T12:14:00+00:00')
      end_time_1 = start_time_1 + 30 * 60
      trip_1 = {
        id: 8,
        driver: driver,
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: start_time_1,
        end_time: end_time_1,
        cost: 36.65,
        rating: 4
      }

      start_time_2 = Time.parse('2015-07-20T12:14:00+00:00')
      end_time_2 = start_time_2 + 60 * 60
      trip_2 = {
        id: 9,
        driver: driver,
        passenger: RideShare::Passenger.new(id: 4, name: "Ada", phone: "412-432-7640"),
        start_time: start_time_2,
        end_time: end_time_2,
        cost: 121.65,
        rating: 3
      }
      driver.add_trip(RideShare::Trip.new(trip_1))
      driver.add_trip(RideShare::Trip.new(trip_2))

      driver.average_revenue.must_equal 82.67
    end
  end


end
