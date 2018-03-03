require 'timecop'
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

  describe "TripDispatcher#request_trip" do
    before do
      @passenger = RideShare::Passenger.new({id: 1, name: "Smithy", phone: "353-533-5334"})
      @dispatcher = RideShare::TripDispatcher.new
    end

    it "should return an instance of Trip" do
      @dispatcher.request_trip(@passenger.id).must_be_instance_of RideShare::Trip
    end

    it "should add the trip to the Dispatchers collection of trips" do
      before_length = @dispatcher.trips.length
      new_trip = @dispatcher.request_trip(@passenger.id)
      @dispatcher.trips.must_include new_trip
      @dispatcher.trips.length.must_equal before_length + 1
    end

    it "should automatically assign a driver to the trip" do
      @dispatcher.request_trip(@passenger.id).driver.must_be_instance_of RideShare::Driver
    end

    it "should should set the assigned driver's status to UNAVAILABLE" do
      new_driver = @dispatcher.drivers.find { |driver| driver.id == 100 }
      new_driver.status.must_equal :AVAILABLE
      new_trip = @dispatcher.request_trip(@passenger.id)
      new_trip_driver = new_trip.driver
      new_trip_driver.status.must_equal :UNAVAILABLE
    end

    it "should not affect the driver's total revenue calculation when starting a new trip" do
      new_driver = @dispatcher.drivers.find { |driver| driver.id == 100 }
      before_new_trip_revenue = new_driver.total_revenue
      before_new_trip_revenue.must_equal 0.0
      new_trip = @dispatcher.request_trip(@passenger.id)
      new_trip_driver = new_trip.driver
      new_trip_driver.id.must_equal 100
      new_trip_driver.total_revenue.must_equal before_new_trip_revenue
    end

    it "should add the trip to the driver's list of trips" do
      driver100 = @dispatcher.drivers.find { |driver| driver.id == 100 }
      driver_trip_count = driver100.trips.length
      new_trip = @dispatcher.request_trip(@passenger.id)
      new_trip_driver = new_trip.driver
      new_trip_driver.id.must_equal driver100.id
      new_trip_driver.trips.must_include new_trip
      new_trip_driver.trips.length.must_equal driver_trip_count + 1
    end

    it "should throw an error if there are no available drivers" do
      available_drivers = @dispatcher.drivers.select{ |driver| driver.status == :AVAILABLE }.length
      available_drivers.times do
        @dispatcher.request_trip(@passenger.id)
      end
      proc {@dispatcher.request_trip(@passenger.id)}.must_raise ArgumentError
    end

    it "should add the trip to the passenger's list of trips" do
      passenger_id = 2
      passenger1 = @dispatcher.passengers.find {|passenger| passenger.id == passenger_id}
      before_length = passenger1.trips.length
      new_trip = @dispatcher.request_trip(passenger_id)

      passenger1.trips.must_include new_trip
      passenger1.trips.length.must_equal before_length + 1
    end

    it "should not yet affect the passenger's total cost calculation when starting a new trip" do
      before_new_trip_spent = @passenger.total_spent
      @dispatcher.request_trip(@passenger.id)
      @passenger.total_spent.must_equal before_new_trip_spent
    end

    it "should not yet affect the passenger's total time calculation when starting a new trip" do
      before_new_trip_time = @passenger.total_time
      @dispatcher.request_trip(@passenger.id)
      @passenger.total_time.must_equal before_new_trip_time
    end

    it "should set a start time for the trip" do
      @dispatcher.request_trip(@passenger.id).start_time.must_be_instance_of Time
    end

    it "should set the start time to Time.now" do
      Timecop.freeze(Time.now) do
        new_trip = @dispatcher.request_trip(@passenger.id)
        new_trip.start_time.to_i.must_equal Time.now.to_i
      end
    end

    it "should set the end time, cost, and rating to nil" do
      @dispatcher.request_trip(@passenger.id).end_time.must_be_nil
      @dispatcher.request_trip(@passenger.id).cost.must_be_nil
      @dispatcher.request_trip(@passenger.id).rating.must_be_nil

    end

    it "should assign the new trip a new id" do
      sorted_trips = @dispatcher.trips.sort_by {|trip| trip.id}
      last_trip = sorted_trips.last
      last_trip_id = last_trip.id
      new_trip = @dispatcher.request_trip(@passenger.id)
      new_trip.id.must_equal last_trip_id + 1
    end

    it "it returns the driver who has not driven in the greatest amount of time" do

      names = ["Minnie Dach", "Antwan Prosacco", "Nicholas Larkin", "Mr. Hyman Wolf", "Jannie Lubowitz"]
      passenger_ids = [2, 3, 4, 5, 6]
      passenger_ids.each.with_index do |id, i|
        new_trip = @dispatcher.request_trip(id)
        driver = new_trip.driver
        driver.name.must_equal names[i]
      end
    end
  end

end
