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

    # Was the trip created properly?
  describe "request_trip method" do
    it "checks if trip was created properly" do
      requested_trip = RideShare::TripDispatcher.new
      new_trip = requested_trip.request_trip(4)

      new_trip.must_be_kind_of RideShare::Trip
    end


      # Were the trip lists for the driver and passenger updated?

      # When I create a new trip with request trip
      # we can call the trips method on the trip dispatcher
      # and if must include the new trip

      # driver - we can access the driver from the new trips
      # and look at the list of trips on that driver
      # and it must include the new trip
    it "checks if trip was added to list of trips" do
      trip_dispatcher = RideShare::TripDispatcher.new

      new_trip = trip_dispatcher.request_trip(3)


      include_trip = trip_dispatcher.trips

      include_trip.must_include new_trip
    end


    it "checks if trip lists were updated for driver" do
      trip_dispatcher = RideShare::TripDispatcher.new
      new_trip = trip_dispatcher.request_trip(3)
      update_driver = new_trip.driver.trips
      update_driver.must_include new_trip

    end


    it "checks if trip lists were updated for passenger" do
      trip_dispatcher = RideShare::TripDispatcher.new
      new_trip = trip_dispatcher.request_trip(3)
      update_passenger = new_trip.passenger.trips
      update_passenger.must_include new_trip
    end

    it "sets the driver's status to UNAVAILABLE" do
      trip_dispatcher = RideShare::TripDispatcher.new
      new_trip = trip_dispatcher.request_trip(3)
      update_status = new_trip.driver.status
      update_status.must_equal :UNAVAILABLE
    end

    it "raises an error when there are no AVAILABLE drivers" do
      trip_dispatcher = RideShare::TripDispatcher.new
      drivers = trip_dispatcher.available?


      drivers.length.times do

        new_trip = trip_dispatcher.request_trip(3)

      end



      proc {

        new_trip = trip_dispatcher.request_trip(3)
      }.must_raise StandardError
    end
  end

    # Was the driver who was selected AVAILABLE?
  describe "available? method" do

    it "returns the first available driver" do
      trip_dispatcher = RideShare::TripDispatcher.new

      trip_dispatcher.available?.must_be_kind_of Array
    end
  end
end
