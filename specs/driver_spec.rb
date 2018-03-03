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
      begin
      RideShare::Driver.new(id: 0, name: "George", vin: "33133313331333133")
      fail
    rescue ArgumentError
      pass
      end
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
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = (start_time + 25 * 60)
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

  describe "add_trip part 2" do

    it 'changes status if end_time equals nil' do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = nil
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
      trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: nil, start_time: start_time, end_time: end_time, rating: 5})

      @driver.add_trip(trip)

      @driver.status.must_equal :UNAVAILABLE
    end
  end

  describe "average_rating method" do
    before do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = (start_time + 25 * 60)
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

  describe "Total Revenue" do
    before do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25

      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")

      trip_one = RideShare::Trip.new({id: 2, driver: @driver, passenger: nil, start_time: start_time, end_time: end_time, cost: 40, rating: 5})

      trip_two = RideShare::Trip.new({id: 8, driver: @driver, passenger: nil, start_time: start_time, end_time: end_time, cost: 25, rating: 3})

      @driver.add_trip(trip_one)
      @driver.add_trip(trip_two)

    end
    it 'calculate total revenue from driver' do

      @driver.total_revenue.must_be_kind_of Float
      @driver.total_revenue.must_equal 49.36
    end
    it 'calculate the average total revenue from driver' do
      @driver.average_revenue.must_be_kind_of Float
      @driver.average_revenue.must_equal 24.68
    end
  end

  describe 'In-Progress method' do
    before do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = nil

      end_time_two = start_time + 25

      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")

      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")

      @trip_one = RideShare::Trip.new({id: 2, driver: @driver, passenger: nil, start_time: start_time, end_time: end_time, cost: 40, rating: 5})

      @trip_two = RideShare::Trip.new({id: 8, driver: @driver, passenger: nil, start_time: start_time, end_time: end_time_two, cost: 25, rating: 3})
      end
    it 'removes trips when end time is nil' do
      @driver.add_trip(@trip_one)
      @driver.add_trip(@trip_two)
      @driver.trips.must_include @trip_one
      @driver.trips.must_include @trip_two
      @driver.in_progress.wont_include @trip_one
      @driver.in_progress.must_include @trip_two
      end
    it 'will not include in_progress trips in total revenue' do
      @driver.add_trip(@trip_one)
      @driver.add_trip(@trip_two)
      @driver.total_revenue.must_equal 18.68
    end
    it 'will not include in_progress trips in average revenue' do
      @driver.add_trip(@trip_one)
      @driver.add_trip(@trip_two)
      @driver.average_revenue.must_equal 18.68
    end
  end





end
