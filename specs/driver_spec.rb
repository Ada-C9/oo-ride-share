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
      @trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: pass, date: "2016-08-08", rating: 5})
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
      trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: nil, date: "2016-08-08", rating: 5})
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

  describe 'calculate_total_rev method' do
    it 'can return total money driver made' do
      driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
      trip1 = RideShare::Trip.new({id: 8, driver: @driver, cost: 15.90, passenger: nil, date: "2016-08-08", rating: 5})
      trip2 = RideShare::Trip.new({id: 8, driver: @driver, cost: 12.10, passenger: nil, date: "2016-08-08", rating: 3})
      driver.add_trip(trip1)
      driver.add_trip(trip2)

      driver.calculate_total_rev.must_be_kind_of Float
      driver.calculate_total_rev.must_equal 24.7
    end
  end

  describe 'total_drive_time' do
    it 'can return total time driver drove' do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
      trip1 = RideShare::Trip.new({id: 8, start_time: start_time, end_time: end_time, driver: driver, cost: 15.90, passenger: nil, date: "2016-08-08", rating: 5})
      trip2 = RideShare::Trip.new({id: 8, start_time: start_time, end_time: end_time, driver: driver, cost: 12.10, passenger: nil, date: "2016-08-08", rating: 3})
      driver.add_trip(trip1)
      driver.add_trip(trip2)

      driver.total_drive_time.must_be_kind_of Integer
      driver.total_drive_time.must_equal 3000
    end
  end

  describe 'avg_rev_per_hour method' do
    it 'can return average driver revenue per hour driving' do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes 24.7
      driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
      trip1 = RideShare::Trip.new({id: 8, start_time: start_time, end_time: end_time, driver: driver, cost: 15.90, passenger: nil, date: "2016-08-08", rating: 5})
      trip2 = RideShare::Trip.new({id: 9, start_time: start_time, end_time: end_time, driver: driver, cost: 12.10, passenger: nil, date: "2016-08-08", rating: 3})
      driver.add_trip(trip1)
      driver.add_trip(trip2)

      driver.avg_rev_per_hour.must_be_close_to 29.64,0.05
    end
  end

  describe 'new_ride method' do
    it 'can add a ride to driver trips' do
      # test if instance of rides
      #test trips.length
    end

    it 'can change driver status to unavailable' do
      # check driver status
    end
  end
end
