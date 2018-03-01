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

  describe 'request_trip method' do
    before do
      @dispatcher = RideShare::TripDispatcher.new
    end

    it "will create a new trip object" do
      @dispatcher.request_trip(2).must_be_instance_of RideShare::Trip
      @dispatcher.request_trip("r").must_be_nil
    end

    it "will add a new trip to trips array" do
     @dispatcher.request_trip(2)
     @dispatcher.trips.length.must_equal 601
    end

    it "changes chosen drivers status to UNAVAILABLE " do
      @dispatcher.request_trip(2).driver.status.must_equal :UNAVAILABLE
      @dispatcher.request_trip(6).driver.status.wont_equal :AVAILABLE

    end

    it "adds a trip to passengers trips" do
      @dispatcher.request_trip(2).passenger.trips.length.must_equal 2
      @dispatcher.request_trip(2).passenger.trips.length.must_equal 3
      @dispatcher.request_trip(2).passenger.trips.length.must_equal 4
    end

    it "adds a trip to drivers trips" do
      #@dispatcher.request_trip(2).driver.trips.length.must_equal 7
      #hmmmm...not sure how to track a random driver
    end

    it "trip contains a nil end_time, cost, and rating" do
      @dispatcher.request_trip(2).end_time.must_be_nil
      @dispatcher.request_trip(2).cost.must_be_nil
      @dispatcher.request_trip(2).rating.must_be_nil
    end

    it "raises argument if no available drivers" do
      47.times {@dispatcher.request_trip(1)}
      # there are 47 available drivers in csv
      # so adding an extra ride request should raise error
      proc{@dispatcher.request_trip(4)}.must_raise ArgumentError
    end

  end

end
