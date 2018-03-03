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
  end # ends "describe "Initializer" do"

  describe "request_trip method" do
    it "checks if the trip was created properly" do
      dispatcher = RideShare::TripDispatcher.new
      new_trip = dispatcher.request_trip(3)
      new_trip.must_be_instance_of RideShare::Trip
    end

    #TODO write this test
    it "checks if trip lists for the driver and passenger were updated" do

    end

    it "checks if the driver who was selected was UNAVAILABLE" do
      # Arrange
      dispatcher = RideShare::TripDispatcher.new

      # Act
      new_trip = dispatcher.request_trip(2)

      # Assert
      new_trip.driver.status.must_equal :UNAVAILABLE
      new_trip.driver.name.must_equal "Emory Rosenbaum"
      binding.pry
      # # available_driver = @drivers.find_driver(2)
      # available_driver.name.must_equal "Emory Rosenbaum"
      # # available_driver.id.must_equal 2
      # available_driver.status.must_equal :UNAVAILABLE
    end

    #TODO write this test
    it "raise an exception if you try to request a trip when there are no AVAILABLE drivers" do
      # Arrange
      dispatcher = RideShare::TripDispatcher.new
      dispatcher.drivers.each do |driver|
        driver.status = :UNAVAILABLE
      end
      # make it so there are no available drivers - how?

      # Act
      new_trip = dispatcher.request_trip(2)

      # Assert
      # use a proc around the act step, and say .must_raise
    end

  end # ends "describe "request_trip method" do"

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
  end # ends "describe "find_driver method" do"

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
  end # ends "describe "find_passenger method" do"

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
  end # ends "describe "loader methods" do"
end
