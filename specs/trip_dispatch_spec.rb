require 'time'
require_relative 'spec_helper'


describe "TripDispatcher class" do

  before do
  @dispatcher_1 = RideShare::TripDispatcher.new
  end

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
      start_time = trip.start_time
      end_time = trip.end_time

      driver.must_be_instance_of RideShare::Driver
      driver.trips.must_include trip
      passenger.must_be_instance_of RideShare::Passenger
      passenger.trips.must_include trip
      start_time.must_be_instance_of Time
      end_time.must_be_instance_of Time

    end
  end
  describe "find_first_available_driver" do

    it "identifies the first available driver" do
      driver_to_assign = @dispatcher_1.find_first_available_driver
      driver_to_assign.must_be_instance_of RideShare::Driver
      status = driver_to_assign.status
      status.must_equal :AVAILABLE
    end
  end

  describe "create_new_trip_id" do

    it "creates a trip ID number that is one higher than the current highest trip ID number" do

      new_trip_id = @dispatcher_1.create_new_trip_id
      new_trip_id.must_be_kind_of Integer
      new_trip_id.to_i.must_equal 601

    end
  end
  # describe "request_trip(passenger_id)" do
  #   it "creates a new instance of Trip" do
  #     test_trip = request_trip(passenger_id) #WALK-O
  #     test_trip.must_be_instance_of Rideshare::Trip #WALK-O
  #     test_trip.driver.must_equal driver_to_be_determined #GOT
  #     test_trip.passenger.must_equal passenger_to_be_determined
  #     test_trip.start_time.to_i.must_be_close_to Time.now.to_i, 2
  #     test_trip.end_time.to_i.must_be_nil
  #     test_trip.cost.must_be_nil
  #     test_trip.rating.must_be_nil
  #   end
  # end
end
