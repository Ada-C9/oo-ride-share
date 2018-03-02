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
    before do

      @trip_data = {
        id: 601,
        driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil
      }
      @trip = RideShare::Trip.new(@trip_data)
    end

    it "Create a new instance of Trip" do
      @trip.must_be_kind_of RideShare::Trip
    end

    it "Automatically assign the first driver whose status is :AVAILABLE to the trip Set the driver's status to :UNAVAILABLE" do
      dispatcher = RideShare::TripDispatcher.new

      first_driver_avalable_before = dispatcher.load_drivers[1]
      first_driver_avalable_before.name.must_equal "Emory Rosenbaum"
      first_driver_avalable_before.id.must_equal 2
      first_driver_avalable_before.status.must_equal :AVAILABLE

      first_driver_avalable = dispatcher.request_trip(1).driver
      first_driver_avalable.name.must_equal "Emory Rosenbaum"
      first_driver_avalable.id.must_equal 2
      first_driver_avalable.status.must_equal :UNAVAILABLE

    end

    it "Update the end time, cost and rating to be nil" do
      dispatcher = RideShare::TripDispatcher.new
      dispatcher.request_trip(1).end_time.must_be_nil
      dispatcher.request_trip(1).cost.must_be_nil
      dispatcher.request_trip(1).rating.must_be_nil
    end



    it "Add the new trip to the collection of trips for the Passenger" do
      dispatcher = RideShare::TripDispatcher.new

      first_passenger = dispatcher.request_trip(1).passenger

      first_passenger.name.must_equal "Nina Hintz Sr."
      first_passenger.id.must_equal 1
    end

    it "Add the new trip to the collection of all Trips in TripDispatcher" do
      dispatcher = RideShare::TripDispatcher.new

      trip = dispatcher.trips.first
      driver = trip.driver
      passenger = trip.passenger

      driver.must_be_instance_of RideShare::Driver
      driver.trips.must_include trip
      passenger.must_be_instance_of RideShare::Passenger
      passenger.trips.must_include trip
    end

    it "Return the newly created trip" do
      dispatcher = RideShare::TripDispatcher.new
      trip = dispatcher.request_trip(1)
      driver = trip.driver
      passenger = trip.passenger
      driver.name.must_equal "Emory Rosenbaum"
      driver.id.must_equal 2
      driver.status.must_equal :UNAVAILABLE
      passenger.name.must_equal "Nina Hintz Sr."
      passenger.id.must_equal 1
      trip.id.must_equal 601
      trip.start_time.must_be_kind_of Time
      trip.end_time.must_be_nil
      trip.cost.must_be_nil
      trip.rating.must_be_nil
    end


  end

end
