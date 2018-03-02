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

  describe "request_trip" do

    # Selected driver: 14,Antwan Prosacco,KPLUTG0L6NW1A0ZRF,AVAILABLE
    # Passenger: 1,Nina Hintz Sr.,560.815.3059
    before do
      @selected_driver = RideShare::Driver.new(id: 14, name: "Antwan Prosacco", vin: "KPLUTG0L6NW1A0ZRF")
      @passenger = RideShare::Passenger.new(id: 1, name: "Nina Hintz Sr.", phone_number: "560.815.3059", trips: [])
      @trip_dispatcher = RideShare::TripDispatcher.new
    end

    it "creates a new instance of Trip" do
      trip = @trip_dispatcher.request_trip(1)
      trip.must_be_instance_of RideShare::Trip
    end

    it "returns the newly created trip" do
      trip = @trip_dispatcher.request_trip(1)

      trip.id.must_equal 601
      trip.driver.id.must_equal 14
      trip.passenger.id.must_equal 1
      trip.start_time.to_i.must_equal Time.now.to_i
      trip.end_time.must_be_nil
      trip.cost.must_be_nil
      trip.rating.must_be_nil
    end

    it "assigns a driver whose most recent trip ended the longest time ago to the trip" do
      trip = @trip_dispatcher.request_trip(1)

      trip.driver.id.must_equal @selected_driver.id
      trip.driver.name.must_equal @selected_driver.name
      trip.driver.vin.must_equal @selected_driver.vin
    end

    it "adds the new trip to the trips for that driver" do
      orig_trip_length = @trip_dispatcher.drivers[14 - 1].trips.length

      trip = @trip_dispatcher.request_trip(1)

      @trip_dispatcher.drivers[14 - 1].trips.length.must_equal orig_trip_length + 1
      @trip_dispatcher.drivers[14 - 1].trips.include?(trip).must_equal true
    end

    it "sets the driver's status to :UNAVAILABLE" do
      @trip_dispatcher.drivers[14 - 1].status.must_equal :AVAILABLE

      @trip_dispatcher.request_trip(1)

      @trip_dispatcher.drivers[14 - 1].status.must_equal :UNAVAILABLE
    end

    it "adds the new trip to the trips for that passenger" do
      orig_trip_length = @trip_dispatcher.passengers[1 - 1].trips.length

      trip = @trip_dispatcher.request_trip(1)

      @trip_dispatcher.passengers[1 - 1].trips.length.must_equal orig_trip_length + 1
      @trip_dispatcher.passengers[1 - 1].trips.include?(trip).must_equal true
    end

    it "adds the new trip to the collection of all trips in TripDispatcher" do
      orig_trip_length = @trip_dispatcher.trips.length

      trip = @trip_dispatcher.request_trip(1)

      @trip_dispatcher.trips.length.must_equal orig_trip_length + 1
      @trip_dispatcher.trips.include?(trip).must_equal true
    end

    it "returns nil when there are no :AVAILABLE divers" do
      @trip_dispatcher.drivers.each do |driver|
        driver.set_status(:UNAVAILABLE)
      end

      @trip_dispatcher.request_trip(1).must_be_nil
    end

    it "assigns right drivers for multiple trips" do
      # Driver 14: Antwan Prosacco (last trip 267 ended 2015-04-23T17:53:00+00:00)
      # Driver 27: Nicholas Larkin (last trip 468 ended 2015-04-28T04:13:00+00:00)
      # Driver 6: Mr. Hyman Wolf (last trip 295 ended 2015-08-14T09:54:00+00:00)
      # Driver 87: Jannie Lubowitz (last trip 73 ended 2015-10-26T01:13:00+00:00)
      # Driver 75: Mohammed Barrows (last trip 184 ended 2016-04-01T16:26:00+00:00)
      trips = []
      5.times do
        trip = @trip_dispatcher.request_trip(1)
        trips << trip
      end

      trips[0].driver.id.must_equal 14
      trips[1].driver.id.must_equal 27
      trips[2].driver.id.must_equal 6
      trips[3].driver.id.must_equal 87
      trips[4].driver.id.must_equal 75
    end

  end

end
