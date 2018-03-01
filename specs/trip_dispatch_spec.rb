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

  describe "request_trip" do
    before do
     # @dispatcher = RideShare::TripDispatcher.new
     # @passenger_id = 21
     # @new_trip = @dispatcher.request_trip(@passenger_id)
   end
    it "creates a new trip" do
      dispatcher = RideShare::TripDispatcher.new
      trip = dispatcher.request_trip(1)

      trip.driver.must_be_kind_of RideShare::Driver
      trip.driver.id.must_equal 2
      trip.passenger.id.must_equal 1
      trip.driver.status.must_equal :UNAVAILABLE
    end

    it "adds current trip" do

      # # dispatcher = RideShare::TripDispatcher.new
      # trips_before = @dispatcher.trips.count
      # @dispatcher.request_trip(1)
      # @dispatcher.trips.count.must_equal trips_before + 1
    end

    it "raises an argument error when no drivers are available" do
      dispatcher = RideShare::TripDispatcher.new
      # dispatcher.drivers.each do |driver|
      #   driver.toggle_status
      # end
      dispatcher.drivers.each do |driver|
        driver.status = :UNAVAILABLE
      end


      proc{dispatcher.request_trip(1)}.must_raise ArgumentError
    end
    it "adds current trip to driver" do



    end
    it "adds current trip to passenger" do
      dispatcher = RideShare::TripDispatcher.new
      trips = [
        RideShare::Trip.new({cost: 5, rating: 3, start_time: Time.parse("2016-04-05T14:01:00+00:00"), end_time: Time.parse("2016-04-05T14:09:00+00:00")}),
        RideShare::Trip.new({cost: 3, rating: 1, start_time: Time.parse("2016-04-05T14:01:00+00:00"), end_time: Time.parse("2016-04-05T14:09:00+00:00")}),
        RideShare::Trip.new({cost: 2, rating: 5, start_time: Time.parse("2016-04-05T14:01:00+00:00"), end_time: Time.parse("2016-04-05T14:09:00+00:00")})
      ]

      passenger = RideShare::Passenger.new(id: 21, trips: trips, name: "Merl Glover III", phone: "1-602-620-2330 x3723")
      # puts passenger.inspect
      trip = dispatcher.request_trip(21)
      # puts trip.inspect
      passenger.trips.length.must_equal 4
      passenger.trips.last.must_equal trip
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
end
