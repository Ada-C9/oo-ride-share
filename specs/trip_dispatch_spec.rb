require 'time'
require 'pry'
require_relative 'spec_helper'


describe "TripDispatcher class" do

  before do

    unavailable_drivers = [
      # All names in this test data set beginwith "X", as do all vins, so as to distinguish this purpose-built dummy set from the production set. For the same reason, all driver ids are > 700.
      RideShare::Driver.new(id: 701, name: "Xernardo Xrosacco", vin: "XBWSS52P9NEYLVDE9", status: :UNAVAILABLE, trips: nil),

      RideShare::Driver.new(id: 702, name: "Xmory Xosenbaum", vin: "XB9WEX2R92R12900E", status: :UNAVAILABLE, trips: nil),

      RideShare::Driver.new(id: 703, name: "Xaryl Xitzsche", vin: "XAL6P2M2XNHC5Y656", status: :UNAVAILABLE, trips: nil),

      RideShare::Driver.new(id: 704, name: "Xeromy X'Keefe DVM", vin: "X1CKRVH55W8S6S9T1", status: :UNAVAILABLE, trips: nil),

      RideShare::Driver.new(id: 705, name: "Xerla Xarquardt", vin: "XAMLE35L3MAYRV1JD", status: :UNAVAILABLE, trips: nil)
    ]

    @dispatcher_1 = RideShare::TripDispatcher.new
    @dispatcher_2_unavail = RideShare::TripDispatcher.new
    @dispatcher_2_unavail.drivers = unavailable_drivers
  end

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
      start_time = trip.start_time
      end_time = trip.end_time

      driver.must_be_instance_of RideShare::Driver
      driver.trips.must_include trip
      passenger.must_be_instance_of RideShare::Passenger
      passenger.trips.must_include trip
      start_time.must_be_instance_of Time
      end_time.must_be_instance_of Time

    end
  end
  describe "find_first_available_driver" do

    it "identifies the first available driver" do
      driver_to_assign = @dispatcher_1.find_first_available_driver
      driver_to_assign.must_be_instance_of RideShare::Driver
      status = driver_to_assign.status
      status.must_equal :AVAILABLE
      name = driver_to_assign.name
      name.must_equal "Emory Rosenbaum"
    end

    it "returns nil when there are no drivers with available status" do
      #The two assertions below just test the test:
      @dispatcher_2_unavail.drivers.count.must_equal 5
      @dispatcher_2_unavail.drivers.find { |driver| driver.id == 701}.wont_be_nil
      #The assertion below is the actual test of the production code.
      @dispatcher_2_unavail.find_first_available_driver.must_be_nil
    end
  end

  describe "create_new_trip_id" do

    it "creates a trip ID number that is one higher than the current highest trip ID number" do
      new_trip_id = @dispatcher_1.create_new_trip_id
      new_trip_id.must_be_kind_of Integer
      new_trip_id.to_i.must_equal 601
    end
  end

  describe "request_trip(passenger_id)" do

    before do
      @test_trip = @dispatcher_1.request_trip(232)
    end

    it "creates a new instance of Trip" do
      @test_trip.must_be_instance_of RideShare::Trip
    end

    it "gives the new trip the correct id" do
      @test_trip.id.must_equal 601
    end

    it "assigns the first available driver" do
      @test_trip.driver.name.must_equal "Emory Rosenbaum"
    end

    it "assigns the passenger with the specified id" do
      @test_trip.passenger.name.must_equal "Creola Bernier PhD"
    end

    it "has an initial cost of nil" do
      @test_trip.cost.must_be_nil
    end

    it "has an initial rating of nil" do
      @test_trip.rating.must_be_nil
    end

    it "has an initial end-time of nil" do
      @test_trip.end_time.must_be_nil
    end

    it "has a start time of approximately the moment the ride was requested" do
      @test_trip.start_time.to_i.must_be_close_to Time.now.to_i, 5
    end

    it "adds the new trip to the TripDispatch's collection" do
      @dispatcher_1.trips.must_include @test_trip
      @dispatcher_1.trips.count.must_equal 601
    end

    it "adds the new trip to the driver's collection" do
      @test_trip.driver.trips.count.must_equal 9
      @test_trip.driver.trips.find { |trip| trip.id == 601 }.wont_be_nil
    end

    it "adds the new trip to the driver's collection" do
      @test_trip.driver.trips.count.must_equal 9
      @test_trip.driver.trips.find { |trip| trip.id == 601 }.wont_be_nil
    end

    it "adds the new trip to the passenger's collection" do
      @test_trip.passenger.trips.count.must_equal 5
      @test_trip.passenger.trips.find { |trip| trip.id == 601 }.wont_be_nil
    end

    it "raises an error if there are no drivers with available status" do

      proc{ @dispatcher_2_unavail.request_trip(232)}.must_raise StandardError

    end
  end
end
