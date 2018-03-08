require 'time'
require_relative 'spec_helper'


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

    before do
      @test_dispatcher = RideShare::TripDispatcher.new
      @count_control_trips = @test_dispatcher.trips.count
      @test_trip = @test_dispatcher.request_trip(5)
    end

    it "trips must increase by 1 everytime request_trip is called" do
      test_dispatcher_2 = RideShare::TripDispatcher.new
      before_trips = test_dispatcher_2.trips.count
      test_trip_2 = test_dispatcher_2.request_trip(5)
      after_trips = test_dispatcher_2.trips.count
      after_trips.must_equal (before_trips + 1)
    end

    it "creates a new instance of trip" do
      @test_trip.must_be_instance_of RideShare::Trip
    end

    it "trip start_time is an instance of Time" do
      @test_trip.start_time.must_be_kind_of Time
    end

    it "request_trip assigned driver status is UNAVAILABLE" do
      @test_trip.driver.status.must_equal :UNAVAILABLE
    end

    it "end_time, trip cost and rating must be equal to nil" do
      @test_trip.end_time.must_be_nil
      @test_trip.cost.must_be_nil
      @test_trip.rating.must_be_nil
    end
  end

  describe "request_trip driver" do

    before do
      @test_dispatcher = RideShare::TripDispatcher.new
      @test_trip_1 = @test_dispatcher.request_trip(1)
      @test_trip_2 = @test_dispatcher.request_trip(2)
      @test_trip_3 = @test_dispatcher.request_trip(3)
    end

    it "first assigned drivers should be Minnie Dach" do
      @test_trip_1.driver.name.must_equal("Minnie Dach")
    end

    it "third assigned drivers should be Nicholas Larkin" do
      @test_trip_3.driver.name.must_equal("Nicholas Larkin")
    end
  end
end
