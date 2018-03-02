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
  end

  describe "request_trip" do
    before do
      @dispatcher = RideShare::TripDispatcher.new
    end

    it "makes new trips and assigns a driver and passenger" do
      new_ride = @dispatcher.request_trip(2)
      new_ride.must_be_instance_of RideShare::Trip
      new_ride.passenger.must_equal 2

    end

    it "updates driver trip info" do
      new_ride = @dispatcher.request_trip(2)
      driver = new_ride.driver
      trips = @dispatcher.find_driver(driver).trips
      trips.must_include new_ride
    end

    it "updates passenger trip info" do
      before = @dispatcher.find_passenger(2).trips.length
      new_ride = @dispatcher.request_trip(2)
      passenger = new_ride.passenger

      after = @dispatcher.find_passenger(passenger).trips.length
      after.must_equal before + 1
    end

    it "finds driver that is :AVAILABLE" do
      driver_id = @dispatcher.find_available
      @dispatcher.find_driver(driver_id).status.must_equal :AVAILABLE
    end

    it "returns argument error if no drivers available" do
      available_drivers = @dispatcher.drivers.find_all { |driver| driver.status == :AVAILABLE }.length

      available_drivers.times do
        new_ride = @dispatcher.request_trip(2)
      end

      proc { new_ride = @dispatcher.request_trip(2) }.must_raise ArgumentError

    end

  end
end
