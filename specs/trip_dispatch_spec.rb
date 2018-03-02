require_relative 'spec_helper'
require 'pry'

describe "TripDispatcher class" do

  before do
    @dispatcher = RideShare::TripDispatcher.new
  end

  describe "Initializer" do
    it "is an instance of TripDispatcher" do
      @dispatcher.must_be_kind_of RideShare::TripDispatcher
    end

    it "establishes the base data structures when instantiated" do
      [:trips, :passengers, :drivers].each do |prop|
        @dispatcher.must_respond_to prop
      end

      @dispatcher.trips.must_be_kind_of Array
      @dispatcher.passengers.must_be_kind_of Array
      @dispatcher.drivers.must_be_kind_of Array
    end
  end

  describe "find_driver method" do
    it "throws an argument error for a bad ID" do
      proc{ @dispatcher.find_driver(0) }.must_raise ArgumentError
    end

    it "finds a driver instance" do
      driver = @dispatcher.find_driver(2)
      driver.must_be_kind_of RideShare::Driver
    end
  end

  describe "find_passenger method" do
    it "throws an argument error for a bad ID" do
      proc{ @dispatcher.find_passenger(0) }.must_raise ArgumentError
    end

    it "throws an argument error for an id > 300" do
      proc{ @dispatcher.find_passenger(330) }.must_raise ArgumentError
    end

    it "finds a passenger instance" do
      passenger = @dispatcher.find_passenger(2)
      passenger.must_be_kind_of RideShare::Passenger
    end
  end

  describe "loader methods" do
    it "accurately loads driver information into drivers array" do
      first_driver = @dispatcher.drivers.first
      last_driver = @dispatcher.drivers.last

      first_driver.name.must_equal "Bernardo Prosacco"
      first_driver.id.must_equal 1
      first_driver.status.must_equal :UNAVAILABLE
      last_driver.name.must_equal "Minnie Dach"
      last_driver.id.must_equal 100
      last_driver.status.must_equal :AVAILABLE
    end

    it "accurately loads passenger information into passengers array" do
      first_passenger = @dispatcher.passengers.first
      last_passenger = @dispatcher.passengers.last

      first_passenger.name.must_equal "Nina Hintz Sr."
      first_passenger.id.must_equal 1
      last_passenger.name.must_equal "Miss Isom Gleason"
      last_passenger.id.must_equal 300
    end

    it "accurately loads trip info and associates trips with drivers and passengers" do
      trip = @dispatcher.trips.first
      driver = trip.driver
      passenger = trip.passenger

      driver.must_be_instance_of RideShare::Driver
      driver.trips.must_include trip
      passenger.must_be_instance_of RideShare::Passenger
      passenger.trips.must_include trip
    end

    it "accurately converts strings to Time objects" do
      trip = @dispatcher.trips.first
      start_time = trip.start_time
      end_time = trip.end_time

      start_time.must_be_kind_of Time
      end_time.must_be_kind_of Time
    end
  end

  describe "#request_trip(passenger_id)" do
    it "returns a Trip instance" do
      passenger_id = 150
      new_trip = @dispatcher.request_trip(passenger_id)
      new_trip.must_be_instance_of RideShare::Trip
    end

    it "accurately assigns nil values" do
      passenger_id = 150
      new_trip = @dispatcher.request_trip(passenger_id)
      new_trip.end_time.must_be_nil
      new_trip.rating.must_be_nil
      new_trip.cost.must_be_nil
    end

    it "must add to the trips array" do
      initial_trips_length = @dispatcher.trips.length
      passenger_id = 150
      new_trip = @dispatcher.request_trip(passenger_id)
      new_trips_length = @dispatcher.trips.length

      new_trips_length.must_equal initial_trips_length + 1
    end

    it "returns nil if no driver is available" do
      new_drivers = []
      @dispatcher.drivers.each do |driver|
        driver.status = :UNAVAILABLE
        new_drivers << driver
      end

      passenger_id = 150
      new_trip = @dispatcher.request_trip(passenger_id)
      new_trip.must_be_nil
    end
  end

  describe "#find_new_driver" do
    it "returns a Driver instance" do
      all_drivers = @dispatcher.drivers
      @dispatcher.find_new_driver(all_drivers).must_be_kind_of RideShare::Driver
    end

    it "returns correct driver" do
      #Driver 14: Antwan Prosacco (last trip 267 ended 2015-04-23T17:53:00+00:00)

      available_drivers = @dispatcher.removes_unavailable_drivers
      new_driver = @dispatcher.find_new_driver(available_drivers)
      new_driver.id.must_equal 14
      new_driver.name.must_equal "Antwan Prosacco"
    end
  end

  describe "#removes_unavailable_drivers" do
    before do
      @available_drivers = @dispatcher.removes_unavailable_drivers
    end

    it "accurately removes_unavailable_drivers" do
      @available_drivers.must_be_kind_of Array
    end

    it "returns an array" do
      @available_drivers.length.must_equal 47
    end
  end
end
