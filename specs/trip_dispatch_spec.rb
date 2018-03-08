require_relative 'spec_helper'
require 'awesome_print'

describe "TripDispatcher class" do
  describe "Initializer" do
    it "001 is an instance of TripDispatcher" do
      dispatcher = RideShare::TripDispatcher.new
      dispatcher.must_be_kind_of RideShare::TripDispatcher
    end

    it "002 establishes the base data structures when instantiated" do
      dispatcher = RideShare::TripDispatcher.new
      [:trips, :passengers, :drivers].each do |prop|
        dispatcher.must_respond_to prop
      end

      dispatcher.trips.must_be_kind_of Array
      dispatcher.passengers.must_be_kind_of Array
      dispatcher.drivers.must_be_kind_of Array
    end
  end

  describe "003 find_driver method" do
    before do
      @dispatcher = RideShare::TripDispatcher.new
    end

    #driver id #trip_spec and driver do this also
    it "004 throws an argument error for a bad ID" do
      proc{ @dispatcher.find_driver(0) }.must_raise ArgumentError
    end

    it "005 finds a driver instance" do
      driver = @dispatcher.find_driver(2)
      driver.must_be_kind_of RideShare::Driver
    end
  end

  describe "find_passenger method" do
    before do
      @dispatcher = RideShare::TripDispatcher.new
    end
    #passenger does not have this
    it "006 throws an argument error for a bad ID" do
      proc{ @dispatcher.find_passenger(0) }.must_raise ArgumentError
    end

    it "007 finds a passenger instance" do
      passenger = @dispatcher.find_passenger(2)
      passenger.must_be_kind_of RideShare::Passenger
    end
  end

  describe "loader methods" do
    it "008accurately loads driver information into drivers array" do
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

    it "009 accurately loads passenger information into passengers array" do
      dispatcher = RideShare::TripDispatcher.new

      first_passenger = dispatcher.passengers.first
      last_passenger = dispatcher.passengers.last

      first_passenger.name.must_equal "Nina Hintz Sr."
      first_passenger.id.must_equal 1
      last_passenger.name.must_equal "Miss Isom Gleason"
      last_passenger.id.must_equal 300
    end

    it "010 accurately loads trip info and associates trips with drivers and passengers" do
      dispatcher = RideShare::TripDispatcher.new


      trip = dispatcher.trips.first
      driver = trip.driver
      passenger = trip.passenger

      driver.must_be_instance_of RideShare::Driver
      driver.trips.must_include trip
      passenger.must_be_instance_of RideShare::Passenger
      passenger.trips.must_include trip
    end

    it "011 parses time into time class" do
      dispatcher = RideShare::TripDispatcher.new

      trip = dispatcher.trips.first
      trip.start_time.must_be_kind_of Time
    end
  end

  describe 'Wave2 tests' do
    before do
      # drivers =
      @dispatcher = RideShare::TripDispatcher.new()
    end
    # # yet_trip =  dispatcher.request_trip(9)
    it "supplies an existing passenger id" do
      yet_trip = @dispatcher.request_trip(9)
      yet_trip.passenger.id.must_equal 9
    end

    it "throws an error for a bad passenger id" do
      proc{@dispatcher.request_trip(0)}.must_raise ArgumentError
    end

    it "creates an instance of a trip" do
      trip1 = @dispatcher.request_trip(9)
      trip1.must_be_kind_of RideShare::Trip
    end

    it " raises an error if no drivers are available" do
      drivers = @dispatcher.drivers
      drivers.each do |driver|
        driver.available?(false)
      end

      proc{
        @dispatcher.request_trip(2)
      }.must_raise ArgumentError
    end

    it "creates a valid id for the trip" do

      previous = @dispatcher.trips.length
      @dispatcher.request_trip(2)

      @dispatcher.trips.length.must_equal previous + 1
    end

    it "updated the driver list of trips correctly" do
      driver = @dispatcher.find_driver(9)
      previous = driver.trips.length

      @dispatcher.drivers.each { |driver_element| driver_element.available?(false)}

      working_driver = @dispatcher.drivers.find { |driver_element| driver_element.id == 9 }
      working_driver.available?(true)
      @dispatcher.request_trip(9)
      #array of driver objects
      working_driver.trips.length.must_equal previous + 1
    end

    it "updated the passenger's trips correctly" do
      passenger = @dispatcher.find_passenger(9)
      previous = passenger.trips.length
      @dispatcher.request_trip(9)
      passenger.trips.length.must_equal previous + 1
    end
    #
    it "updates all trips correctly" do
      trips = @dispatcher.trips
      previous = trips.length
      @dispatcher.request_trip(6)

      trips.length.must_equal previous + 1
    end
  end

  describe "Wave3 tests- additional TripDispatcher logic" do
    before do
      # drivers =
      @dispatcher = RideShare::TripDispatcher.new()
    end

    it "has no drivers whose last trip is nil" do
      driver = @dispatcher.find_available_driver

      if driver.trips.length == 0
        driver.status.must_equal :AVAILABLE
      else
        driver.trips.last.end_time.wont_be_nil
        driver.status.must_equal :AVAILABLE
      end
    end

    it "drivers that have had no trips are available" do
      @dispatcher.drivers.each { |driver_element| driver_element.available?(false)}
      working_driver = @dispatcher.drivers.find { |driver_element| driver_element.id == 100 }
      working_driver.available?(true)
      trip = @dispatcher.request_trip(9)
      trip.driver.id.must_equal 100
    end

    it "prioritizes drivers who have the oldest most recent trip" do
      @dispatcher.request_trip(9).driver.id.must_equal 100
      @dispatcher.request_trip(10).driver.id.must_equal 14
      @dispatcher.request_trip(11).driver.id.must_equal 27
      @dispatcher.request_trip(12).driver.id.must_equal 6
      @dispatcher.request_trip(13).driver.id.must_equal 87
      @dispatcher.request_trip(9).driver.id.must_equal 75
    end

    it "prioritizes drivers that have had no trips" do
      @dispatcher.request_trip(9).driver.id.must_equal 100
    end
  end
end
