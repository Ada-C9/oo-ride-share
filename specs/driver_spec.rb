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
  describe "total_revenu" do
    it 'can calculate the total_revenu'do
    start_time = Time.parse('2015-05-20 12:10:00 +0000')
    end_time = Time.parse('2015-05-20 12:15:00 +0000')

    pass = RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640")
    driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
    trip = RideShare::Trip.new({id: 8, driver: driver, passenger: pass, start_time: start_time, end_time: end_time ,rating: 5,cost:10})
    driver.add_trip(trip)

    assert_in_delta driver.total_revenue, 6.68, 0.01
  end

  it 'can calculate total revenu after multiple trips' do
    start_time = Time.parse('2015-05-20 12:10:00 +0000')
    end_time = Time.parse('2015-05-20 12:15:00 +0000')

    second_trip_start = Time.parse('2016-05-20 12:10:00 +0000')
    second_trip_end = Time.parse('2016-05-20 12:10:00 +0000')

    pass = RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640")
    driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
    trip = RideShare::Trip.new({id: 8, driver: driver, passenger: pass, start_time: start_time, end_time: end_time ,rating: 5,cost:10})
    second_trip = RideShare::Trip.new({id: 8, driver: driver, passenger: pass, start_time: second_trip_start, end_time: second_trip_end,rating: 5,cost:10})
    driver.add_trip(trip)
    driver.add_trip(second_trip)

    assert_in_delta driver.total_revenue, 13.36, 0.01
  end
end

describe "total_revenu per hour" do
  it 'can calculate the total_revenu per hour' do
    start_time = Time.parse('2015-05-20 12:10:00 +0000')
    end_time = Time.parse('2015-05-20 13:10:00 +0000')

    pass = RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640")

    driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")

    trip = RideShare::Trip.new({id: 8, driver: driver, passenger: pass, start_time: start_time, end_time:end_time ,rating: 5,cost:126.65})

    driver.add_trip(trip)
    driver.total_revenue_per_hour.must_equal 100.0
  end

  it 'can calculatethe the total revenu per hour for multiple trips' do
    start_time = Time.parse('2015-05-20 12:10:00 +0000')
    end_time = Time.parse('2015-05-20 13:10:00 +0000')

    second_start = Time.parse('2016-09-20 5:10:00 +0000')
    second_end = Time.parse('2016-09-20 6:10:00 +0000')
    pass = RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640")

    driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")

    trip = RideShare::Trip.new({id: 8, driver: driver, passenger: pass, start_time: start_time, end_time:end_time ,rating: 5,cost:126.65})

    second_trip = RideShare::Trip.new({id: 8, driver: driver, passenger: pass, start_time: second_start, end_time:second_end ,rating: 5,cost:126.65})
    driver.add_trip(trip)
    driver.add_trip(second_trip)

    driver.total_revenue_per_hour.must_equal 100.0
  end

  it 'will return 0 for a pending trip' do
    start_time = Time.parse('2015-05-20 12:10:00 +0000')

    pass = RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640")

    driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")

    trip = RideShare::Trip.new({id: 8, driver: driver, passenger: pass, start_time: start_time, end_time: :PENDING,rating: 5,cost:126.65})

    driver.add_trip(trip)
    driver.total_revenue_per_hour.must_equal 0
  end
end

describe "add trip method" do
  before do
    pass = RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640")
    @driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
    start_time = Time.parse('2015-05-20T12:14:00+00:00')
    end_time = start_time + (1500)

    @trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: pass, start_time:start_time, end_time:end_time, rating: 5})
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
    end_time = start_time + (1500)
    trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: nil, start_time:start_time, end_time:end_time, rating: 5})
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
end
