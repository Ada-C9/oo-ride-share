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

  describe "total_revenue method" do
    before do
      @trips = [RideShare::Trip.new({rating: 3, cost: 10}), RideShare::Trip.new({rating: 5, cost: 10})]
    end
    it 'returns a total_revenue' do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
        vin: "1C9EVBRM0YBC564DZ", trips: @trips)
      result = @driver.total_revenue
      expected_revenue = 13.36
      result.must_equal expected_revenue
    end

    it 'return 0 if the driver didnt have any trips ' do
      trips = []
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
        vin: "1C9EVBRM0YBC564DZ", trips: trips)
      result = @driver.total_revenue
      expected_revenue = 0
      result.must_equal expected_revenue
    end

    it 'return 0 if the drivers trips costs less than the fee charged' do
      trips = [RideShare::Trip.new({rating: 3, cost: 1.5})]
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
        vin: "1C9EVBRM0YBC564DZ", trips: trips)
      result = @driver.total_revenue
      expected_revenue = 0
      result.must_equal expected_revenue
    end
  end

  describe "average_revenue_per_hr method" do
    before do
      @start_time_1 = Time.parse('2016-08-08T16:01:00+00:00')
      @end_time_1 = @start_time_1 + 40*60
      @start_time_2 = Time.parse('2016-08-08T16:01:00+00:00')
      @end_time_2 = @start_time_2 + 20*60

      @trips = [RideShare::Trip.new({rating: 3, cost: 10, start_time: @start_time_1, end_time: @end_time_1}),
        RideShare::Trip.new({rating: 5, cost: 10, start_time: @start_time_2, end_time: @end_time_2})]
    end
    
    it 'returns the average_revenue_per_hr' do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ", trips: @trips)
      result = @driver.average_revenue_per_hr
      expected_ave_revenue = 13.36
      result.must_equal expected_ave_revenue
    end

    it 'returns 0 if the driver has no trips' do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ", trips: [])
      result = @driver.average_revenue_per_hr
      expected_ave_revenue = 0
      result.must_equal expected_ave_revenue
    end
  end
end
