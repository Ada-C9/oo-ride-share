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

    it "accurately loads trip info for time" do
      dispatcher = RideShare::TripDispatcher.new
      first_trip = dispatcher.trips.first

      first_trip.start_time.must_be_kind_of Time
      first_trip.start_time.must_equal Time.parse("2016-04-05T14:01:00+00:00")
      first_trip.end_time.must_be_kind_of Time
      first_trip.end_time.must_equal Time.parse("2016-04-05T14:09:00+00:00")

      last_trip = dispatcher.trips.last

      last_trip.start_time.must_be_kind_of Time
      last_trip.start_time.must_equal Time.parse("2016-04-25T02:59:00+00:00")
      last_trip.end_time.must_be_kind_of Time
      last_trip.end_time.must_equal Time.parse("2016-04-25T03:06:00+00:00")
    end
  end

  describe "request_trip" do
    before do
      @dispatcher = RideShare::TripDispatcher.new
      @passenger_id = 21
      @new_trip = @dispatcher.request_trip(@passenger_id)
    end

    it "return a new trip" do
      @new_trip.must_be_instance_of RideShare::Trip
      @new_trip.id.must_equal @new_trip.id
    end

    it "sets nil values for end_time, cost, and rating" do
      @new_trip.end_time.must_be_nil
      @new_trip.cost.must_be_nil
      @new_trip.rating.must_be_nil
    end

    it "adds the trip to passenger's trips" do
      trip_passenger = @new_trip.passenger
      trip_passenger.must_be_instance_of RideShare::Passenger
      trip_passenger.id.must_equal @passenger_id
      trip_passenger.trips.last.must_equal @new_trip
      trip_passenger.trips.last.id.must_equal @new_trip.id
    end

    it "adds the trip to driver's trips" do
      trip_driver = @new_trip.driver
      trip_driver.must_be_instance_of RideShare::Driver
      trip_driver.trips.last.must_equal @new_trip
      trip_driver.trips.last.id.must_equal @new_trip.id
    end

    it "add the trip to all trips" do
      size_before =  @dispatcher.trips.size
      @dispatcher.request_trip(23)
      @dispatcher.trips.size.must_equal size_before + 1
    end

    it "selects an available driver" do
      before_ids = @dispatcher.drivers.map { |driver| driver.id if driver.is_available? }
      new_test_trip = @dispatcher.request_trip(24)
      after_ids = @dispatcher.drivers.map { |driver| driver.id if driver.is_available? }

      before_ids.include?(new_test_trip.driver.id).must_equal true
      (before_ids - after_ids).must_equal [new_test_trip.driver.id]
      new_test_trip.driver.status.must_equal :UNAVAILABLE
    end

    it "return nil if no drivers are available" do
      while @dispatcher.drivers.count { |driver| driver.is_available? } > 0
        @dispatcher.request_trip(27)
      end
      @dispatcher.request_trip(27).must_be_nil
    end
  end

end
