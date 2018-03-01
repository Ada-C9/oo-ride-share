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
  end # describe loader methods

  describe "request_trip(passenger_id) method" do
    before do
      @dispatcher = RideShare::TripDispatcher.new
      @result = @dispatcher.request_trip(1)
    end

    it "returns a proper trip" do
      @result.must_be_kind_of RideShare::Trip
    end

    it "assigns the first driver with available status" do
      first_available_driver_id = 2
      second_available_driver_id = 3
      @result.driver.id.must_equal first_available_driver_id
      result = @dispatcher.request_trip(1)
      result.driver.id.must_equal second_available_driver_id
    end

    it "sets the selected driver's status to unavailable" do
      @result.driver.status.must_equal :UNAVAILABLE
    end

    it "returns an error if there are no available drivers" do
    end

    it "uses the current time for the start time" do
      current_time = Time.now
      @result.start_time.to_a.must_equal current_time.to_a
    end

    it "assigns end time, cost, and rating to nil" do
      @result.end_time.must_be_nil
      @cost.must_be_nil
      @rating.must_be_nil
    end

    it "updates the trips list" do
      @dispatcher.trips.must_include @result
    end

    it "updates the trip list for the driver" do
      result = @result.driver.trips
      result.must_include @result
    end

    it "updates the trip list for the passenger" do
      result = @result.passenger.trips
      result.must_include @result
    end
  end # describe TripDispatcher#request_trip(passenger_id)


end # describe TripDispatcher
