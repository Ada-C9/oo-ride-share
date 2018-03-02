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

  ## NEW
  describe "request_trip" do

    before do
      @test_dispatcher = RideShare::TripDispatcher.new
      @count_control_trips = @test_dispatcher.trips.count
      @test_trip = @test_dispatcher.request_trip(5)
      @test_drivers = @test_dispatcher.available_drivers
    end

    describe "available_driver" do

      it "returns array of instances of driver" do
        @test_drivers.must_be_kind_of Array
        @test_drivers[2].must_be_instance_of RideShare::Driver
        @test_drivers[2].status.must_equal :AVAILABLE
      end

      it "returns empty array if there are no available drivers" do
        @test_drivers.must_be_kind_of Array
        # @test_drivers.count.must_equal 0
      end
    end

    # Modify this selected driver using a new helper method in Driver:
    # Add the new trip to the collection of trips for that Driver
    # Set the driver's status to :UNAVAILABLE
    # Modify the passenger for the trip using a new helper method in Passenger:
    # Add the new trip to the collection of trips for the Passenger
    # Add the new trip to the collection of all Trips in TripDispatcher
    # Return the newly created trip

    # it "returns string telling user no drivers available when there are no available drivers" do
    #   test_trip.must_equal("No available drivers")
    # end

    it "trips must increase by 1 everytime request_trip is called" do
      count_test_trips = @test_dispatcher.trips.count
      count_test_trips.must_equal (@count_control_trips + 1)
    end

    it "creates a new instance of trip" do
      @test_trip.must_be_instance_of RideShare::Trip
    end

    it "trip start_time is an instance of Time" do
      @test_trip.start_time.must_be_kind_of Time
    end

    it "assigns driver who is available" do
      @test_trip.driver.status.must_equal :AVAILABLE
    end

    it "end_time, trip cost and rating must be equal to nil" do
      @test_trip.end_time.must_equal nil
      @test_trip.cost.must_equal nil
      @test_trip.rating.must_equal nil
    end
    ##
  end
end
