require_relative 'spec_helper'
require 'pry'

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

    describe "request_trip method" do
      before do
        @trip_dispatcher =  RideShare::TripDispatcher.new
      end

      it "returns instance of trip" do

        trip = @trip_dispatcher.request_trip(45)
        trip.must_be_instance_of RideShare::Trip
      end


      it "create a new trip requested by a passenger" do

        passenger_id = 54
        @trip_dispatcher.request_trip(passenger_id).must_be_instance_of RideShare::Trip

      end

      it "return an updated trip collections including the new trip in passenger class" do

        passenger_id = 54
        new_trip = @trip_dispatcher.request_trip(passenger_id)

        new_trip.passenger.add_trip(new_trip)
        new_trip.passenger.trips.must_include new_trip
        new_trip.passenger.must_be_instance_of RideShare::Passenger


      end


      it " appropriately adds the new trip to the collection of trips the driver" do

        passenger_id = 10

        new_trip = @trip_dispatcher.request_trip(passenger_id)
        new_trip.driver.add_trip(new_trip)

        new_trip.driver.must_be_instance_of RideShare::Driver

      end

      it "updates the status  to UNAVAILABLE after adding trip for the choosen driver" do

        passenger_id = 10
        new_trip = @trip_dispatcher.request_trip(passenger_id)

        new_trip.driver.add_trip(new_trip)
        new_trip.driver.set_status(new_trip).must_equal :UNAVAILABLE

      end


      it "raises standard error when there are no :AVAILABLE divers" do

        @trip_dispatcher.drivers.each do |driver|
          driver.set_status(:UNAVAILABLE)
        end

        proc{@trip_dispatcher.request_trip(1)}.must_raise StandardError
      end

      it " appropriately adds the new trip to the collection of all trips for the trip_dispatcher" do
        trip_length = @trip_dispatcher.trips.length

        trip = @trip_dispatcher.request_trip(1)

        @trip_dispatcher.trips.length.must_equal trip_length + 1
      end



      it "Use the current time for the start time and end time to nil " do

        trip_data = {
          id: 8,
          driver: RideShare::Driver.new(id: 2, name: "Lovelace", vin: "12345678912345678", status: :AVAILABLE),
          passenger: RideShare::Passenger.new(id: 10, name: "Ada", phone: "412-432-7640"),
          start_time: Time.now,
          end_time: nil,
          cost: nil,
          rating: nil
        }

        new_trip = @trip_dispatcher.request_trip(10)

        new_trip.driver.add_trip(new_trip)
        trip = RideShare::Trip.new(trip_data)

        trip.start_time.must_be_instance_of Time
        trip.end_time.must_be_nil

        trip.cost.must_be_nil
        trip.rating.must_be_nil

      end

      it "assigns the driver who's last trip was the longest time ago" do
        # selected_driver = RideShare::Driver.new(id: 14, name: "Antwan Prosacco", vin: "KPLUTG0L6NW1A0ZRF")
        # passenger = RideShare::Passenger.new(id: 1, name: "Nina Hintz Sr.", phone_number: "560.815.3059", trips: [])

        trips = []
        5.times do
          trip = @trip_dispatcher.request_trip(1)
          trips << trip
        end

        trips[0].driver.id.must_equal 14
        trips[0].driver.name.must_equal "Antwan Prosacco"
        trips[0].driver.set_status(1).must_equal :UNAVAILABLE
        trips[1].driver.id.must_equal 27
        trips[2].driver.id.must_equal 6
        trips[3].driver.id.must_equal 87
        trips[4].driver.id.must_equal 75
      end
    end


  end
end
