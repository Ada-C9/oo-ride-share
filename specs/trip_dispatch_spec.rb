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

  describe "request_trip method" do

    it "can create a new trip requested by a passenger" do
      passenger_id = 90
      trip_dispatcher = RideShare::TripDispatcher.new

      trip_dispatcher.request_trip(passenger_id).must_be_kind_of RideShare::Trip
    end

    it "return an updated trip collections including the new trip in passenger class" do
      passenger_id = 100
      trip_dispatcher = RideShare::TripDispatcher.new

      new_trip = trip_dispatcher.request_trip(passenger_id)

      new_trip.passenger.add_new_trip(new_trip)
      new_trip.passenger.trips.must_include new_trip

      new_trip.driver.add_new_trip(new_trip)
      new_trip.driver.trips.must_include new_trip
    end

    it "returns the status of chosen driver" do
      passenger_id = 10
      trip_dispatcher = RideShare::TripDispatcher.new
      new_trip = trip_dispatcher.request_trip(passenger_id)

      new_trip.driver.status.must_equal :AVAILABLE
    end

    it "can return the first driver who is available" do
      trip_dispatcher = RideShare::TripDispatcher.new

      first_driver_id = 14
      second_driver_id = 27
      third_driver_id = 6
      fourth_driver_id = 87
      fifth_driver_id = 75

      first_driver = trip_dispatcher.find_driver(first_driver_id)
      second_driver = trip_dispatcher.find_driver(second_driver_id)
      third_driver = trip_dispatcher.find_driver(third_driver_id)
      fourth_driver = trip_dispatcher.find_driver(fourth_driver_id)
      fifth_driver = trip_dispatcher.find_driver(fifth_driver_id)

      passenger_id_1 = 10
      passenger_id_2 = 20
      passenger_id_3 = 30
      passenger_id_4 = 40
      passenger_id_5 = 50

      new_trip_1 = trip_dispatcher.request_trip(passenger_id_1)
      new_trip_1.driver.add_new_trip(new_trip_1)

      new_trip_2 = trip_dispatcher.request_trip(passenger_id_2)
      new_trip_2.driver.add_new_trip(new_trip_2)

      new_trip_3 = trip_dispatcher.request_trip(passenger_id_3)
      new_trip_3.driver.add_new_trip(new_trip_3)

      new_trip_4 = trip_dispatcher.request_trip(passenger_id_4)
      new_trip_4.driver.add_new_trip(new_trip_4)

      new_trip_5 = trip_dispatcher.request_trip(passenger_id_5)
      new_trip_5.driver.add_new_trip(new_trip_5)

      new_trip_1.driver.must_equal first_driver
      new_trip_2.driver.must_equal second_driver
      new_trip_3.driver.must_equal third_driver
      new_trip_4.driver.must_equal fourth_driver
      new_trip_5.driver.must_equal fifth_driver

    end
  end

end
