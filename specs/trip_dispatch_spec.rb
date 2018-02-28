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
      @dispatcher.drivers.map { |driver| driver.status = :UNAVAILABLE }
      passenger_id = 150
      new_trip = @dispatcher.request_trip(passenger_id)
      new_trip.must_be_nil
    end

    it "only selects a driver who is available" do
      passenger_id = 150
      new_trip = @dispatcher.request_trip(passenger_id)
      new_trip.driver.id.must_equal 2
      new_trip.driver.name.must_equal "Emory Rosenbaum"
      new_trip.driver.status.must_equal :AVAILABLE
    end

  end
end
