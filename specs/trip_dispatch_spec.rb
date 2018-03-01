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

    it "accurately loads trip information into trips array" do
      dispatcher = RideShare::TripDispatcher.new
      first_trip = dispatcher.trips.first
      last_trip = dispatcher.trips.last

      first_trip.id.must_equal 1
      first_trip.driver.id.must_equal 1
      first_trip.passenger.id.must_equal 54
      first_trip.start_time.must_equal Time.parse('2016-04-05T14:01:00+00:00')
      first_trip.start_time.must_be_instance_of Time
      first_trip.end_time.must_equal Time.parse('2016-04-05T14:09:00+00:00')
      first_trip.end_time.must_be_instance_of Time
      first_trip.cost.must_equal 17.39
      first_trip.rating.must_equal 3

      last_trip.id.must_equal 600
      last_trip.driver.id.must_equal 61
      last_trip.passenger.id.must_equal 168
      last_trip.start_time.must_be_instance_of Time
      last_trip.start_time.must_equal Time.parse('2016-04-25T02:59:00+00:00')
      last_trip.end_time.must_be_instance_of Time
      last_trip.end_time.must_equal Time.parse('2016-04-25T03:06:00+00:00')
      last_trip.cost.must_equal 26.76
      last_trip.rating.must_equal 3
    end
  end

  describe "#request_trip(passenger_id)" do
    before do
      @dispatcher = RideShare::TripDispatcher.new
      @first_passenger_request = @dispatcher.request_trip(1)
      @second_passenger_request = @dispatcher.request_trip(2)
      @last_passenger_request = @dispatcher.request_trip(300)
    end

    it "Create a new instance of Trip" do
      @first_passenger_request.must_be_instance_of RideShare::Trip
      @first_passenger_request.must_be_instance_of RideShare::Trip
    end

    it "Find the person requesting a trip" do
      @first_passenger_request.passenger.must_equal @dispatcher.find_passenger(1)
      @first_passenger_request.passenger.name.must_equal "Nina Hintz Sr."
      @last_passenger_request.passenger.must_equal @dispatcher.find_passenger(300)
      @last_passenger_request.passenger.name.must_equal "Miss Isom Gleason"
    end

    it "Raise ArgumentError if passenger id doesn't exist" do
      proc{ @dispatcher.request_trip(400) }.must_raise ArgumentError
    end

    it "Automatically assign a driver to the trip" do
      @first_passenger_request.driver.must_be_instance_of RideShare::Driver
      @last_passenger_request.driver.must_be_instance_of RideShare::Driver
    end

    it "Choose a driver whose status is :AVAILABLE" do
      @first_passenger_request.driver.id.must_equal 2
      @second_passenger_request.driver.id.must_equal 3
      @last_passenger_request.driver.id.must_equal 6
    end

    it "Choose the first driver whose status is :AVAILABLE" do
      @first_passenger_request.driver.name.must_equal "Emory Rosenbaum"
      @second_passenger_request.driver.name.must_equal "Daryl Nitzsche"
      @last_passenger_request.driver.name.must_equal "Mr. Hyman Wolf"
    end

    it "Returns nil if there are no drivers AVAILABLE" do
      50.times {@first_passenger_request}
      @first_passenger_request.driver.must_equal 0
      @first_passenger_request.driver.must_equal nil
    end

    it "Use the current time for the start time" do
      @first_passenger_request.start_time.must_be_instance_of Time
      (@first_passenger_request.start_time.to_i - Time.now.to_i).must_equal 0
      @last_passenger_request.start_time.must_be_instance_of Time
      (@last_passenger_request.start_time.to_i - Time.now.to_i).must_equal 0
    end

    it "End date, cost and rating will all be nil
    " do
    @first_passenger_request.end_time.must_equal nil
    @first_passenger_request.cost.must_equal nil
    @first_passenger_request.rating.must_equal nil
    @last_passenger_request.end_time.must_equal nil
    @last_passenger_request.cost.must_equal nil
    @last_passenger_request.rating.must_equal nil
  end

end
end
