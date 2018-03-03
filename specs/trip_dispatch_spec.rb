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

    it "stores start_time as instances of Time" do
      dispatcher = RideShare::TripDispatcher.new

      all_start_times = dispatcher.trips.all? { |trips| trips.start_time.class == Time }

      all_start_times.must_equal true


    end

    it "stores end_time as instances of Time" do
      dispatcher = RideShare::TripDispatcher.new

      all_end_times = dispatcher.trips.all? { |trips| trips.end_time.class == Time }

      all_end_times.must_equal true
    end
  end

  describe "#assign_driver" do

    it "assigns the driver to the available driver whose most recent trip ending is the oldest compared to today" do
      dispatcher = RideShare::TripDispatcher.new
      trip_1 = dispatcher.request_trip(1)
      trip_2 = dispatcher.request_trip(2)
      trip_3 = dispatcher.request_trip(3)
      trip_4 = dispatcher.request_trip(4)
      trip_5 = dispatcher.request_trip(5)

      new_trips = [trip_1, trip_2, trip_3, trip_4, trip_5]

      all_trips = new_trips.all? { |trips| trips.class == RideShare::Trip }

      all_trips.must_equal true

      assigned_drivers = new_trips.all? { |trips| trips.driver.class == RideShare::Driver }

      assigned_drivers.must_equal true

      trip_1.driver.id.must_equal 14
      trip_2.driver.id.must_equal 27
      trip_3.driver.id.must_equal 6
      trip_4.driver.id.must_equal 87
      trip_5.driver.id.must_equal 75
    end

    it "raises error if there are no drivers available" do
      dispatcher = RideShare::TripDispatcher.new
      # 46 drivers originally available
      passenger_id = 1
      46.times do |request_trip|
        dispatcher.request_trip(passenger_id)
      end

      proc{dispatcher.request_trip(2)}.must_raise ArgumentError
    end
  end

  describe "#request_trip(passenger_id)" do
    before do
      @dispatcher = RideShare::TripDispatcher.new
      @passenger = @dispatcher.find_passenger(3)
      @driver = @dispatcher.find_driver(14)

      @initial_trips_length = @dispatcher.trips.length
      @initial_passenger_trips_length = @passenger.trips.length
      @initial_driver_trips_length = @driver.trips.length

      @new_trip = @dispatcher.request_trip(3)

    end

    it "returns/creates new instance of Trip" do
      @new_trip.must_be_kind_of RideShare::Trip
    end

    it "adds the new Trip to the collection of trips in TripDispatcher" do
      @dispatcher.trips.length.must_equal @initial_trips_length + 1
    end

    it "adds the new Trip to the collection of trips for Passenger" do
      @passenger.trips.length.must_equal @initial_passenger_trips_length + 1
    end

    it "adds the new Trip to the collection of trips for Driver" do
      @driver.trips.length.must_equal @initial_driver_trips_length + 1
    end

    it "changes drivers status to :UNAVAILABLE" do
      @driver.status.must_equal :UNAVAILABLE
    end

    it "assigns new trip id (trip ids in dispatcher are in consecutive order)" do
      @new_trip.id.must_equal 601
    end

    it "makes the start time and instance of time" do
      @new_trip.start_time.must_be_kind_of Time
    end

    it "assigns end_time, cost, and rating of trip to 'nil' as it is in progress" do
      @new_trip.end_time.must_be_nil
      @new_trip.cost.must_be_nil
      @new_trip.rating.must_be_nil
    end

    it "is set up for specific attributes and data types" do
      [:id, :passenger, :driver, :start_time, :end_time, :cost, :rating].each do |prop|
        @new_trip.must_respond_to prop
      end

      @new_trip.id.must_be_kind_of Integer
      @new_trip.driver.must_be_kind_of RideShare::Driver
      @new_trip.passenger.must_be_kind_of RideShare::Passenger

    end

  end
end
