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

  describe "#request_trip(passenger_id)" do
    before do
      @dispatcher = RideShare::TripDispatcher.new

      @new_trip = @dispatcher.request_trip(3)

    end

    it "creates new instance of Trip" do

      @new_trip.must_be_kind_of RideShare::Trip

    end

    it "assigns the first driver with status available" do
      @new_trip.driver.id.must_equal 2
    end
    #
    it "adds the new Trip to the collection in TripDispatcher" do

      @dispatcher.trips.length.must_equal 601

    end

    it "adds the new Trip to the collection of trips for Passenger" do
      passenger = @dispatcher.find_passenger(3)
      passenger.trips.length.must_equal 3
    end

    it "add the new Trip to the collection of trips for Driver" do
      driver = @dispatcher.find_driver(2)
      driver.trips.length.must_equal 9
    end

    it "changes drivers status to :UNAVAILABLE" do
      driver = @dispatcher.find_driver(2)
      driver.status.must_equal :UNAVAILABLE
    end




  end
end
