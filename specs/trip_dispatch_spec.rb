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
  describe "find_available_drivers" do
    it "returns an array of all drivers that are available" do
      dispatcher = RideShare::TripDispatcher.new
      dispatcher.find_available_drivers.each do |driver|
        driver.status.must_equal :AVAILABLE
      end
      dispatcher.find_available_drivers.must_be_kind_of Array
    end
  end
  describe "select_driver" do
    before do
      @dispatcher = RideShare::TripDispatcher.new
    end

    it "will not return a driver with a trip already in progress" do
      @dispatcher.select_driver.trips.each do |trip|
        trip.end_time.wont_be_nil
      end
    end
  end

  describe "request_trip" do
    before do
      @dispatcher = RideShare::TripDispatcher.new
      @new_trip = @dispatcher.request_trip(25)
    end

    it "creates a new trip instance" do
      @new_trip.must_be_instance_of RideShare::Trip
    end

    it "Changes the driver's status to unavailable" do
      @new_trip.driver.status.must_equal :UNAVAILABLE
    end

    it "sets the current time as the start_time" do
      @new_trip.start_time.wont_be_nil
      @new_trip.start_time.must_be_instance_of Time
    end

    it "sets the end_time, cost, and rating to nil" do
      @new_trip.end_time.must_be_nil
      @new_trip.cost.must_be_nil
      @new_trip.rating.must_be_nil
    end

    it "updates the driver's trip list" do
      @new_trip.driver.trips.must_include @new_trip
    end

    it "updates the passenger's trip list" do
      @new_trip.passenger.trips.must_include @new_trip
    end

    it "updates the total trips" do
      @dispatcher.trips.must_include @new_trip
    end
  end
end
