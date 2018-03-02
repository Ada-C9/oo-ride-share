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
  end # Initializer

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
  end # find_driver

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
  end # find_passenger

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

    it "uses Time instances for trip start and end times" do
      dispatcher = RideShare::TripDispatcher.new

      trip = dispatcher.trips.first
      trip.start_time.must_be_instance_of Time

    end
  end # loader methods

  describe "#request_trip" do

    it "raises argument error if no id provided" do
      dispatcher = RideShare::TripDispatcher.new
      proc {
        dispatcher.request_trip()
      }.must_raise ArgumentError
    end

    it "raises argument error if inappropriate passenger id provided" do
      dispatcher = RideShare::TripDispatcher.new
      proc {
        dispatcher.request_trip(892)
      }.must_raise ArgumentError
      proc {
        dispatcher.request_trip("whatever")
      }.must_raise ArgumentError
    end

    it "raises argument error if no drivers are available" do
      dispatcher = RideShare::TripDispatcher.new
      dispatcher.drivers.each {|driver| driver.turn_off}
      proc {
        dispatcher.request_trip(14)
      }.must_raise ArgumentError
    end

    it "returns instance of trip" do
      dispatcher = RideShare::TripDispatcher.new
      result = dispatcher.request_trip(45)
      result.must_be_instance_of RideShare::Trip
    end

    it "the returned trip has correct data" do
      dispatcher = RideShare::TripDispatcher.new
      pass = dispatcher.find_passenger(32)
      original_trips = pass.trips.length
      result = dispatcher.request_trip(32)
      result.driver.must_be_instance_of RideShare::Driver
      result.passenger.must_be_instance_of RideShare::Passenger
      result.passenger.trips.length.must_equal original_trips + 1
      result.end_time.must_be_nil
    end

    it "updates the passanger appropriately" do
      dispatcher = RideShare::TripDispatcher.new
      pass = dispatcher.find_passenger(24)
      original_trips = pass.trips.length
      result = dispatcher.request_trip(24)
      result.passenger.trips.length.must_equal original_trips + 1
    end

    it "updates the driver appropriately" do
      dispatcher = RideShare::TripDispatcher.new
      result = dispatcher.request_trip(98)
      result.driver.status.must_equal :UNAVAILABLE
    end

  end # Describbe #request_trip
end  # Describe TripDispatcher class
