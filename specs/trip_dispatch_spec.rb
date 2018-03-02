require_relative 'spec_helper'
require 'pry'

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

    it "creates instances of Time for Trip start and end times" do
      dispatcher = RideShare::TripDispatcher.new
      trip = dispatcher.trips.first

      trip.start_time.must_be_instance_of Time
      trip.end_time.must_be_instance_of Time

    end
  end

  describe "find available driver" do
    before do
      @dispatcher = RideShare::TripDispatcher.new
      @driver = @dispatcher.find_driver(100)
      @passenger = @dispatcher.find_passenger(1)
      @driver_before_trips = @driver.trips.length
      @passenger_before_trips = @passenger.trips.length
    end

    it "chooses drivers with no trips first" do
      @dispatcher.find_available_driver.name.must_equal "Minnie Dach"
    end

    it "assigns the available driver with the longest time since their last trip to trip" do
      @dispatcher.request_trip(1).driver.name.must_equal "Minnie Dach"
      @dispatcher.request_trip(1).driver.name.must_equal "Antwan Prosacco"
      @dispatcher.request_trip(1).driver.name.must_equal "Nicholas Larkin"
      @dispatcher.request_trip(1).driver.name.must_equal "Mr. Hyman Wolf"
      @dispatcher.request_trip(1).driver.name.must_equal "Jannie Lubowitz"
    end

  end

  describe "request trip" do
    before do
      @dispatcher = RideShare::TripDispatcher.new
      @driver = @dispatcher.find_driver(100)
      @passenger = @dispatcher.find_passenger(1)
      @driver_before_trips = @driver.trips.length
      @passenger_before_trips = @passenger.trips.length
    end

    it "throws an error for invalid passenger id" do
      proc {
        @dispatcher.request_trip()
      }.must_raise ArgumentError

      proc {
        @dispatcher.request_trip(0)
      }.must_raise ArgumentError

      proc {
        @dispatcher.request_trip("string")
      }.must_raise ArgumentError

      proc {
        @dispatcher.request_trip(301)
      }.must_raise ArgumentError
    end

    it "returns a new instance of trip" do
      @dispatcher.request_trip(1).must_be_instance_of RideShare::Trip
    end
    
    it "throws an error if there are no available drivers" do
      proc {
        101.times do
          @dispatcher.request_trip(1)
        end
      }.must_raise ArgumentError
    end

    it "uses current time for start time" do
      @dispatcher.request_trip(1).start_time.must_be_within_delta Time.now
    end

    it "returns nil for end time, cost, and rating" do
      @dispatcher.request_trip(1).end_time.must_be_nil
      @dispatcher.request_trip(1).cost.must_be_nil
      @dispatcher.request_trip(1).rating.must_be_nil
    end

    it "adds a new trip to driver" do
      @dispatcher.request_trip(1)
      @driver_before_trips.must_equal @driver.trips.length - 1
    end

    it "adds a new trip to passenger" do
      @dispatcher.request_trip(1)
      @passenger_before_trips.must_equal @passenger.trips.length - 1
    end

    it "adds a new trip to Trip Dispatcher trips array" do
      before = @dispatcher.trips.length
      @dispatcher.request_trip(1)
      before.must_equal @dispatcher.trips.length - 1
    end
  end
end
