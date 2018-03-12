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

  describe "request_trip" do
    it "request_trip creates a new trip" do
      dispatcher = RideShare::TripDispatcher.new
      trip = dispatcher.request_trip(1)

      trip.driver.must_be_kind_of RideShare::Driver
      trip.driver.id.must_equal 2
      trip.passenger.id.must_equal 1
      trip.driver.status.must_equal :UNAVAILABLE
    end

    it "raises an argument error when no drivers are available" do
      dispatcher = RideShare::TripDispatcher.new
      dispatcher.drivers.each do |driver|
        driver.toggle_status
      end

      proc{dispatcher.request_trip(1)}.must_raise ArgumentError
    end

    it "request_trip adds current trip to driver" do
      dispatcher = RideShare::TripDispatcher.new
      new_trip = dispatcher.request_trip(1)
      driver = new_trip.driver

      driver.trips.last.must_equal new_trip
    end

    it "request_trip adds current trip to passenger" do
      dispatcher = RideShare::TripDispatcher.new
      passenger = dispatcher.find_passenger(21)
      number_of_trips = passenger.trips.length
      new_trip = dispatcher.request_trip(21)

      passenger.trips.length.must_equal number_of_trips + 1
      passenger.trips.last.must_equal new_trip
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
end
