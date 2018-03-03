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

  describe "request_trip and find_driver_to_accept_trip methods" do
    before do
      @dispatcher = RideShare::TripDispatcher.new
    end

    it "returns an instance of Trip" do
      @dispatcher.request_trip(1).must_be_instance_of RideShare::Trip

    end

    it "assigns the expected passenger" do
      new_trip = @dispatcher.request_trip(1)
      new_trip.passenger.id.must_equal 1
      new_trip.passenger.name.must_equal "Nina Hintz Sr."
    end

    it "assigns the expected driver first 5 iterations" do
      created_trips = []

      5.times {created_trips << @dispatcher.request_trip(1)}

      created_trips[0].driver.id.must_equal 100
      created_trips[0].driver.name.must_equal "Minnie Dach"

      created_trips[1].driver.id.must_equal 14
      created_trips[1].driver.name.must_equal "Antwan Prosacco"

      created_trips[2].driver.id.must_equal 27
      created_trips[2].driver.name.must_equal "Nicholas Larkin"

      created_trips[3].driver.id.must_equal 6
      created_trips[3].driver.name.must_equal "Mr. Hyman Wolf"

      created_trips[4].driver.id.must_equal 87
      created_trips[4].driver.name.must_equal "Jannie Lubowitz"

    end

    it "raises error if there aren't any available drivers" do
      @dispatcher.drivers.each {|driver| driver.make_driver_unavailable}

      proc{ @dispatcher.request_trip(1) }.must_raise StandardError
    end

    it "raises error if there aren't any available drivers who are not on a trip" do
      @dispatcher.drivers.each {|driver| driver.make_driver_unavailable unless driver.id == 2}

      driver = @dispatcher.drivers.find {|driver| driver.id == 2}

      start_time = Time.parse('2018-2-27T12:14:00+00:00')
      trip_data = {
        id: 8,
        driver: driver,
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"), start_time: start_time
      }
      trip = RideShare::Trip.new(trip_data)
      driver.add_trip(trip)

      proc{ @dispatcher.request_trip(1) }.must_raise StandardError
    end
  end

end
