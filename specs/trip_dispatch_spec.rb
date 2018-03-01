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
      a = trip.start_time
      b = trip.end_time

      driver.must_be_instance_of RideShare::Driver
      driver.trips.must_include trip
      passenger.must_be_instance_of RideShare::Passenger
      passenger.trips.must_include trip
      b.must_be_instance_of Time
      b.must_be_instance_of Time
    end
  end

  describe "request_trip method" do
    before do
      @dispatcher = RideShare::TripDispatcher.new
    end

    it "raises an ArgumentError for an invalid id" do
      proc {@dispatcher.request_trip(0)}.must_raise ArgumentError
      proc {@dispatcher.request_trip("yay")}.must_raise ArgumentError
      proc {@dispatcher.request_trip(-1)}.must_raise ArgumentError
      proc {@dispatcher.request_trip(0)}.must_raise ArgumentError
    end

    it "inputs nil for end_time, cost, and rating" do
      @dispatcher.request_trip(1).end_time.must_be_nil
      @dispatcher.request_trip(1).cost.must_be_nil
      @dispatcher.request_trip(1).rating.must_be_nil
    end

    it "new trip must be instance of RideShare::Trip" do
      @dispatcher.request_trip(1).must_be_instance_of RideShare::Trip
    end

    it "assigns first AVAILABLE driver to the trip" do
      @dispatcher.request_trip(1).driver.id.must_equal 2
    end

    it "changes driver's status to UNAVAILABLE" do
      @dispatcher.request_trip(1).driver.status.must_equal :UNAVAILABLE
    end

    it "correctly sets the start_time" do
      @dispatcher.request_trip(1).start_time.must_be_instance_of Time
    end

    it "throws an error if no drivers are available" do
      proc {
        50.times do
        @dispatcher.request_trip(1)
        end
        @dispatcher.request_trip(1)
      }.must_raise ArgumentError
    end

    it "updates dispatcher's number of rides" do
      @dispatcher.trips.length.must_equal 600
      @dispatcher.request_trip(1)
      @dispatcher.trips.length.must_equal 601
    end

    it "updates passenger's number of rides" do
      @dispatcher.passengers.first.id.must_equal 1
      @dispatcher.passengers.first.trips.length.must_equal 2
      @dispatcher.request_trip(1)
      @dispatcher.passengers.first.trips.length.must_equal 3
    end



  end
end
