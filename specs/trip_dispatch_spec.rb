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

  describe "request_trip method" do
    before do
      @dispatcher = RideShare::TripDispatcher.new
      @all_trips_before = @dispatcher.trips.length
      @passenger_trips_before = @dispatcher.find_passenger(1).trips.length
      @driver_trips_before = @dispatcher.find_driver(14).trips.length
      @driver_status_before = @dispatcher.find_driver(14).status
      @new_trip = @dispatcher.request_trip(1)
    end

    it "creates an accurate trip" do
      @new_trip.must_be_instance_of RideShare::Trip
      @new_trip.id.must_equal 601
      @new_trip.passenger.id.must_equal 1
      @new_trip.passenger.name.must_equal "Nina Hintz Sr."
      @new_trip.driver.id.must_equal 14
      @new_trip.driver.name.must_equal "Antwan Prosacco"
      @new_trip.end_time.must_be_nil
      @new_trip.cost.must_be_nil
      @new_trip.rating.must_be_nil
      @new_trip.driver.status.must_equal :UNAVAILABLE
    end

    it "raises an error if a trip is requested for a new passenger (not in database)" do
      proc { @dispatcher.request_trip(301) }.must_raise ArgumentError
    end

    it "updates all trip lists" do
      @dispatcher.trips.must_include @new_trip
      @dispatcher.find_passenger(1).trips.must_include @new_trip
      @dispatcher.find_driver(14).trips.must_include @new_trip

      all_trips_after = @dispatcher.trips.length
      passenger_trips_after = @dispatcher.find_passenger(1).trips.length
      driver_trips_after = @dispatcher.find_driver(14).trips.length

      all_trips_after - @all_trips_before = 1
      passenger_trips_after - @passenger_trips_before = 1
      driver_trips_after - @driver_trips_before = 1
    end

    it "selects a driver that is available and changes their status" do
      @driver_status_before.must_equal :AVAILABLE
      @new_trip.driver.status.must_equal :UNAVAILABLE
    end
  end

  describe "new_trip_id method" do
    it "creates a trip with a new id" do
      dispatcher = RideShare::TripDispatcher.new
      initial_trip_ids = dispatcher.trips.map { |trip| trip.id }
      new_trip = dispatcher.request_trip(2)
      initial_trip_ids.wont_include new_trip.id
    end
  end

  describe "available_drivers method" do
    it "returns an array of available drivers" do
      dispatcher = RideShare::TripDispatcher.new
      dispatcher.available_drivers.must_be_kind_of Array
      dispatcher.available_drivers.each do |driver|
        driver.must_be_instance_of RideShare::Driver
        driver.status.must_equal :AVAILABLE
      end
    end

    it "raises an error if all drivers are unavailable" do
      dispatcher = RideShare::TripDispatcher.new
      dispatcher.drivers.each do |driver|
        if driver.status == :AVAILABLE
          driver.change_status
        end
        driver.status.must_equal :UNAVAILABLE
      end

      proc { dispatcher.request_trip(3) }.must_raise StandardError
    end
  end

  describe "most_recent_trip_by_driver method" do
    before do
      dispatcher = RideShare::TripDispatcher.new
      @most_recent_trips = dispatcher.most_recent_trip_by_driver
    end

    it "returns an array of trips" do
      @most_recent_trips.must_be_kind_of Array
      @most_recent_trips.each do |trip|
        trip.must_be_instance_of RideShare::Trip
      end
    end

    it "each trip has a unique driver" do
      unique_drivers = @most_recent_trips.map {|trip| trip.driver}.uniq
      @most_recent_trips.length.must_equal unique_drivers.length
    end

    it "includes the last (most recently completed) trip for each driver" do
      last_trip_driver_14 = @most_recent_trips.find do |trip|
        trip.driver.id == 14
      end

      last_trip_driver_27 = @most_recent_trips.find do |trip|
        trip.driver.id == 27
      end

      last_trip_driver_14.end_time.must_equal Time.parse("2015-04-23T17:53:00+00:00")
      last_trip_driver_27.end_time.must_equal Time.parse("2015-04-28T04:13:00+00:00")
    end
  end

  describe "select_driver" do
    it "returns a driver" do
      dispatcher = RideShare::TripDispatcher.new
      dispatcher.select_driver.must_be_kind_of RideShare::Driver
    end

    it "returns the least recently utilized driver when a new trip is requested" do
      dispatcher = RideShare::TripDispatcher.new

      trip_1 = dispatcher.request_trip(1)
      trip_1.driver.id.must_equal 14
      trip_1.driver.name.must_equal "Antwan Prosacco"

      trip_2 = dispatcher.request_trip(2)
      trip_2.driver.id.must_equal 27
      trip_2.driver.name.must_equal "Nicholas Larkin"

      trip_3 = dispatcher.request_trip(3)
      trip_3.driver.id.must_equal 6
      trip_3.driver.name.must_equal "Mr. Hyman Wolf"

      trip_4 = dispatcher.request_trip(4)
      trip_4.driver.id.must_equal 87
      trip_4.driver.name.must_equal "Jannie Lubowitz"

      trip_5 = dispatcher.request_trip(4)
      trip_5.driver.id.must_equal 75
      trip_5.driver.name.must_equal "Mohammed Barrows"
    end
  end
end
