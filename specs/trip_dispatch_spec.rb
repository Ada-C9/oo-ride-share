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
    it 'return a new trip' do
      dispatcher = RideShare::TripDispatcher.new
      expected_trip_id = dispatcher.trips.size
      new_trip = dispatcher.request_trip(21)

      new_trip.must_be_instance_of RideShare::Trip
      new_trip.id.must_equal expected_trip_id
    end

    it 'adds the trip to passenger and driver trips' do
      dispatcher = RideShare::TripDispatcher.new
      new_trip = dispatcher.request_trip(22)

      new_trip.passenger.must_be_instance_of RideShare::Passenger
      new_trip.passenger.id.must_equal 22
      new_trip.passenger.trips.last.must_equal new_trip
      new_trip.passenger.trips.last.id.must_equal new_trip.id

      new_trip.driver.must_be_instance_of RideShare::Driver
      new_trip.driver.trips.last.must_equal new_trip
      new_trip.driver.trips.last.id.must_equal new_trip.id
    end

    it 'add the trip to all trips' do
      dispatcher = RideShare::TripDispatcher.new
      size_before =  dispatcher.trips.size
      dispatcher.request_trip(23)
      dispatcher.trips.size.must_equal size_before + 1
    end

    it 'selects an available driver' do
      dispatcher = RideShare::TripDispatcher.new
      available_drivers_ids = dispatcher.drivers.map { |driver| driver.id if driver.is_available? }
      new_trip = dispatcher.request_trip(24)
      
      available_drivers_ids.include?(new_trip.driver.id).must_equal true
      new_trip.driver.status.must_equal :UNAVAILABLE
    end
  end

end
