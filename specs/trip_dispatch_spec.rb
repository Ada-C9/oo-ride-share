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

describe "available_drivers" do

  it "Should return status available to any driver" do
    available = RideShare::TripDispatcher.new
    available.available_drivers.sample.status.must_equal :AVAILABLE
  end
end

  describe "request_trip" do

    it "The driver must become unavailable after trip is requested " do
      trip = RideShare::TripDispatcher.new
      trip.request_trip(3).driver.status.must_equal :UNAVAILABLE
    end

    it "passanger must be a passanger in the passanger array" do
      trip = RideShare::TripDispatcher.new
      trip.request_trip(3).passenger.id.must_equal 3
    end

    it "should return nil for end time, cost and rating" do
      trip = RideShare::TripDispatcher.new
      trip.request_trip(3).end_time.must_be_nil
      trip.request_trip(3).cost.must_be_nil
      trip.request_trip(3).rating.must_be_nil
    end

    it "Should create an integer id for the new trip" do
      trip = RideShare::TripDispatcher.new
      trip.request_trip(3).id.must_be_kind_of Integer
    end

    it "New trip is added to trips instance variable" do
      trip = RideShare::TripDispatcher.new
      id_to_test = trip.request_trip(3).id
      ids = []
      trip.trips.each do |trip|
        id = trip.id
        ids << id
      end
      ids.include?(id_to_test).must_equal true
    end

    it "New trip is added to drivers trip" do
      trip = RideShare::TripDispatcher.new
      new_trip = trip.request_trip(3)
      ids = []
      new_trip.driver.trips.each do |trip|
        id = trip.id
        ids << id
      end
      ids.include?(new_trip.id).must_equal true
    end

    it "New trip is added to passanger trip" do
      trip = RideShare::TripDispatcher.new
      new_trip = trip.request_trip(3)
      ids = []
      new_trip.passenger.trips.each do |trip|
        id = trip.id
        ids << id
      end
      ids.include?(new_trip.id).must_equal true
    end

    it "Should raise an argument error if there are no available drivers for the new trip." do
      trip = RideShare::TripDispatcher.new
      trip.drivers.each do |driver|
        if driver.status == :AVAILABLE
          driver.status = :UNAVAILABLE
        end
      end
      proc {trip.request_trip(3)}.must_raise ArgumentError
    end
  end

  describe "driver_longest_not_driving" do
    it "should return first the driver with longest not working and so on" do
      dispatcher = RideShare::TripDispatcher.new
      dispatcher.request_trip(3).driver.id.must_equal 14
      dispatcher.request_trip(2).driver.id.must_equal 27
      dispatcher.request_trip(1).driver.id.must_equal 6
      dispatcher.request_trip(1).driver.id.must_equal 87
      dispatcher.request_trip(1).driver.id.must_equal 75
    end
  end


end
