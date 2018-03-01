require_relative 'spec_helper'

describe "Passenger class" do

  before do
    # 1,Nina Hintz Sr.,560.815.3059
    # 98,Ms. Winston Emard,1F9Z5CF13VV8041ND,AVAILABLE
    # 17,Federico Bins V,W092FDPH6FNNK102M,AVAILABLE
    # 46,98,1,2016-06-28T06:39:00+00:00,2016-06-28T07:24:00+00:00,13.04,2
    # 272,17,1,2015-09-14T08:25:00+00:00,2015-09-14T09:23:00+00:00,24.25,4
    @passenger = RideShare::Passenger.new(id: 1, name: "Nina Hintz Sr.", phone_number: "560.815.3059", trips: [])
    @driver_1 = RideShare::Driver.new(id: 98, name: "Ms. Winston Emard", vin: "1F9Z5CF13VV8041ND", status: :AVAILABLE, trips: [])
    @driver_2 = RideShare::Driver.new(id: 17, name: "Federico Bins V", vin: "W092FDPH6FNNK102M", status: :AVAILABLE, trips: [])
    @trip_1 = RideShare::Trip.new(id: 46, driver: @driver_1, passenger: @passenger, start_time: Time.parse('2016-06-28T06:39:00+00:00'), end_time: Time.parse('2016-06-28T07:24:00+00:00'), cost: 13.04, rating: 2)
    @trip_2 = RideShare::Trip.new(id: 272, driver: @driver_2, passenger: @passenger, start_time: Time.parse('2015-09-14T08:25:00+00:00'), end_time: Time.parse('2015-09-14T09:23:00+00:00'), cost: 24.25, rating: 4)
    @in_progress_trip = RideShare::Trip.new(id: 601, driver: 101, passenger: 1, start_time: Time.now, end_time: nil , cost: 10.00, rating: nil)
  end

  describe "Passenger instantiation" do

    it "is an instance of Passenger" do
      @passenger.must_be_kind_of RideShare::Passenger
    end

    it "throws an argument error with a bad ID value" do
      proc{ RideShare::Passenger.new(id: 0, name: "Smithy")}.must_raise ArgumentError
    end

    it "sets trips to an empty array if not provided" do
      @passenger.trips.must_be_kind_of Array
      @passenger.trips.length.must_equal 0
    end

    it "is set up for specific attributes and data types" do
      [:id, :name, :phone_number, :trips].each do |prop|
        @passenger.must_respond_to prop
      end

      @passenger.id.must_be_kind_of Integer
      @passenger.name.must_be_kind_of String
      @passenger.phone_number.must_be_kind_of String
      @passenger.trips.must_be_kind_of Array
    end

  end

  describe "trips property" do

    it "each item in array is a Trip instance" do
      @passenger.add_trip(@trip_1)
      @passenger.add_trip(@trip_2)

      @passenger.trips.each do |trip|
        trip.must_be_kind_of RideShare::Trip
      end
    end

    it "all Trips must have the same Passenger id" do
      @passenger.add_trip(@trip_1)
      @passenger.add_trip(@trip_2)

      @passenger.trips.each do |trip|
        trip.passenger.id.must_equal 1
      end
    end

  end

  describe "get_drivers method" do

    it "returns an array" do
      @passenger.add_trip(@trip_1)
      @passenger.add_trip(@trip_2)

      drivers = @passenger.get_drivers
      drivers.must_be_kind_of Array
      drivers.length.must_equal 2
    end

    it "all items in array are Driver instances" do
      @passenger.get_drivers.each do |driver|
        driver.must_be_kind_of RideShare::Driver
      end
    end

  end

  describe "total_cost" do

    it "calculates that passenger's total amount of money spent" do
      @passenger.add_trip(@trip_1)
      @passenger.add_trip(@trip_2)

      @passenger.total_cost.must_equal (13.04 + 24.25)
    end

    it "returns 0 if there is no trip for this passenger" do
      @passenger.total_cost.must_equal 0
    end

    it "ignores in-progress trips" do
      @passenger.add_trip(@trip_1)
      @passenger.add_trip(@trip_2)
      @passenger.add_trip(@in_progress_trip)

      @passenger.total_cost.must_equal (13.04 + 24.25)
    end

  end

  describe "total_time" do

    it "calculates that passenger's total time spent on all trips" do
      @passenger.add_trip(@trip_1)
      @passenger.add_trip(@trip_2)
      expected_total_time = @trip_1.duration + @trip_2.duration

      @passenger.total_time.must_equal expected_total_time
    end

    it "returns 0 if there is no trip for this passenger" do
      @passenger.total_time.must_equal 0
    end

    it "ignores in-progress trips" do

    end

  end

end
