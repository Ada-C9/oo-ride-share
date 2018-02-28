require_relative 'spec_helper'
require_relative '../lib/trip'
require_relative '../lib/driver'
require_relative '../lib/passenger'
require_relative '../lib/trip_dispatcher'

describe "TripDispatcher class" do

  describe "Initializer" do
    it "is an instance of TripDispatcher" do
      dispatcher = RideShare::TripDispatcher.new
      dispatcher.must_be_kind_of RideShare::TripDispatcher
    end

    it "establishes the base data structures when instantiated" do
      dispatcher = RideShare::TripDispatcher.new
      [:trips, :passengers, :drivers].each do |prop|
        dispatcher.must_respond_to prop
      end

      dispatcher.trips.must_be_kind_of Array
      dispatcher.passengers.must_be_kind_of Array
      dispatcher.drivers.must_be_kind_of Array
    end
  end

  describe "find_driver method" do
    before do
      @dispatcher = RideShare::TripDispatcher.new
    end

    it "throws an argument error for a bad ID" do
      proc{ @dispatcher.find_driver(0) }.must_raise ArgumentError
    end

    it "finds a driver instance" do
      driver = @dispatcher.find_driver(2)
      driver.must_be_kind_of RideShare::Driver
    end
  end

  describe "find_passenger method" do
    before do
      @dispatcher = RideShare::TripDispatcher.new
    end

    it "throws an argument error for a bad ID" do
      proc{ @dispatcher.find_passenger(0) }.must_raise ArgumentError
    end

    it "finds a passenger instance" do
      passenger = @dispatcher.find_passenger(2)
      passenger.must_be_kind_of RideShare::Passenger
    end
  end

  describe "loader methods" do
    it "accurately loads driver information into drivers array" do
      dispatcher = RideShare::TripDispatcher.new

      first_driver = dispatcher.drivers.first
      last_driver = dispatcher.drivers.last

      first_driver.name.must_equal "Bernardo Prosacco"
      first_driver.id.must_equal 1
      first_driver.status.must_equal :UNAVAILABLE
      last_driver.name.must_equal "Minnie Dach"
      last_driver.id.must_equal 100
      last_driver.status.must_equal :AVAILABLE
    end

    it "accurately loads passenger information into passengers array" do
      dispatcher = RideShare::TripDispatcher.new

      first_passenger = dispatcher.passengers.first
      last_passenger = dispatcher.passengers.last

      first_passenger.name.must_equal "Nina Hintz Sr."
      first_passenger.id.must_equal 1
      last_passenger.name.must_equal "Miss Isom Gleason"
      last_passenger.id.must_equal 300
    end

    it "accurately loads trip info and associates trips with drivers and passengers" do
      dispatcher = RideShare::TripDispatcher.new

      trip = dispatcher.trips.first
      driver = trip.driver
      passenger = trip.passenger

      driver.must_be_instance_of RideShare::Driver
      driver.trips.must_include trip
      passenger.must_be_instance_of RideShare::Passenger
      passenger.trips.must_include trip
    end
  end

  describe "request_trip" do

    # Driver: 2,Emory Rosenbaum,1B9WEX2R92R12900E,AVAILABLE
    # 118,2,234,2016-01-07T14:41:00+00:00,2016-01-07T14:56:00+00:00,28.95,5
    # 140,2,206,2015-07-21T02:01:00+00:00,2015-07-21T02:11:00+00:00,19.69,2
    # Passenger: 1,Nina Hintz Sr.,560.815.3059
    # 46,98,1,2016-06-28T06:39:00+00:00,2016-06-28T07:24:00+00:00,13.04,2
    # 272,17,1,2015-09-14T08:25:00+00:00,2015-09-14T09:23:00+00:00,24.25,4
    before do
      @driver_trip_1 = RideShare::Trip.new(id: 118, driver: 2, passenger: 234, start_time: Time.parse('2016-01-07T14:41:00+00:00'), end_time: Time.parse('2016-01-07T14:56:00+00:00'), cost: 28.95, rating: 5)
      @driver_trip_2 = RideShare::Trip.new(id: 140, driver: 2, passenger: 206, start_time: Time.parse('2015-07-21T02:01:00+00:00'), end_time: Time.parse('2015-07-21T02:11:00+00:00'), cost: 19.69, rating: 2)
      @driver = RideShare::Driver.new(id: 2, name: "Emory Rosenbaum", vin: "1B9WEX2R92R12900E", status: :AVAILABLE, trips: [@driver_trip_1, @driver_trip_2])
      @passenger_trip_1 = RideShare::Trip.new(id: 46, driver: 98, passenger: 1, start_time: Time.parse('2016-06-28T06:39:00+00:00'), end_time: Time.parse('2016-06-28T07:24:00+00:00'), cost: 13.04, rating: 2)
      @passenger_trip_2 = RideShare::Trip.new(id: 272, driver: 17, passenger: 1, start_time: Time.parse('2015-09-14T08:25:00+00:00'), end_time: Time.parse('2015-09-14T09:23:00+00:00'), cost: 24.25, rating: 4)
      @passenger = RideShare::Passenger.new(id: 1, name: "Nina Hintz Sr.", phone_number: "560.815.3059", trips: [@passenger_trip_1, @passenger_trip_2])
      @trip_dispatcher = RideShare::TripDispatcher.new
    end

    # Ignore any in-progress trips (end_time is nil) for calculation
    # Add new tests (driver_spec & passenger_spec) for this new situation (in-progress trip added)
    it "creates a new instance of Trip" do
      @trip = @trip_dispatcher.request_trip(1)
      @trip.must_be_instance_of RideShare::Trip
    end

    it "returns the newly created trip" do
      @trip = @trip_dispatcher.request_trip(1)

      @trip.id.must_equal 601
      @trip.driver.id.must_equal 2
      @trip.passenger.id.must_equal 1
      @trip.start_time.to_i.must_equal Time.now.to_i
      @trip.end_time.to_i.must_equal Time.now.to_i
      @trip.cost.must_equal 0
      @trip.rating.must_equal 1
    end

    it "assigns a driver to the trip (use first AVAILABLE driver from the file)" do
      @trip = @trip_dispatcher.request_trip(1)

      @trip.driver.id.must_equal @driver.id
      @trip.driver.name.must_equal @driver.name
      @trip.driver.vin.must_equal @driver.vin
    end

    it "uses the current time for the start_time" do
      @trip = @trip_dispatcher.request_trip(1)

      @trip.start_time.to_i.must_equal Time.now.to_i
    end

    # Extra tests
    it "assigns nil to end_time, cost and rating" do
      @trip = @trip_dispatcher.request_trip(1)

      @trip.end_time.to_i.must_equal Time.now.to_i
      @trip.cost.must_equal 0
      @trip.rating.must_equal 1
    end

    it "adds the new trip to the trips for that driver" do
      orig_trip_length = @trip_dispatcher.drivers[2 - 1].trips.length

      @trip_dispatcher.request_trip(1)

      @trip_dispatcher.drivers[2 - 1].trips.length.must_equal orig_trip_length + 1
    end

    it "sets the driver's status to :UNAVAILABLE" do
      @trip_dispatcher.request_trip(1)

      @trip_dispatcher.drivers[2 - 1].status.must_equal :UNAVAILABLE
    end

    it "adds the new trip to the trips for that passenger" do
      orig_trip_length = @trip_dispatcher.passengers[1 - 1].trips.length

      @trip_dispatcher.request_trip(1)

      @trip_dispatcher.passengers[1 - 1].trips.length.must_equal orig_trip_length + 1
    end

    it "adds the new trip to the collection of all trips in TripDispatcher" do
      orig_trip_length = @trip_dispatcher.trips.length

      @trip_dispatcher.request_trip(1)

      @trip_dispatcher.trips.length.must_equal orig_trip_length + 1
    end

    it "returns nil when there are no :AVAILABLE divers" do
      @trip_dispatcher.drivers.each do |driver|
        driver.set_status(:UNAVAILABLE)
      end

      @trip_dispatcher.request_trip(1).must_be_nil
    end

  end

end
