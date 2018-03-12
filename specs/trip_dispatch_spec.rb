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

    it 'start_time and end_time parsed' do
      dispatcher = RideShare::TripDispatcher.new
      dispatcher.trips.first.start_time.must_be_instance_of Time
      dispatcher.trips.first.end_time.must_be_instance_of Time

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

  describe 'request_trip method' do
    before do
      @dispatcher = RideShare::TripDispatcher.new
      @result = @dispatcher.request_trip(10)
    end

    it 'was created properly' do
      @result.must_be_kind_of RideShare::Trip
    end

    it 'returns a new trip' do
      first_available_driver_id_file = 14
      last_trip_id_file = 600
      expected_trip_id = last_trip_id_file + 1

      @result.id.must_equal expected_trip_id
      @result.driver.id.must_equal first_available_driver_id_file
      @result.passenger.id.must_equal 10

    end

    it 'uses current time for start_time when new trip is created' do
      @result.start_time.to_s.must_equal Time.now.to_s
    end

    it 'assigns end_time, costs, and rating into nil for the new trip'do
      @result.rating.must_be_nil
      @result.cost.must_be_nil
      @result.end_time.must_be_nil
    end

    it 'returns error when requested a trip with an invalid or none passenger ID' do
      # when no passenger id
      proc {@dispatcher.request_trip()
      }.must_raise ArgumentError

      # when passenger id is invalid
      proc {@dispatcher.request_trip(500)
      }.must_raise ArgumentError
    end

    it 'updated the trip list for the driver' do
      result = @result.driver.trips
      result.must_include @result
    end

    it 'updated the trip list for the passenger ' do
      result = @result.passenger.trips
      result.must_include @result

    end

    it 'assigns the first driver available' do
      expected_first_available_driver_id = 14
      expected_first_available_driver = 'Antwan Prosacco'
      @result.driver.id.must_equal expected_first_available_driver_id
      @result.driver.name.must_equal expected_first_available_driver

    end

    it 'returns error when no drivers are available' do
      @dispatcher.drivers.map {|driver| driver.unavailable}
      proc {@dispatcher.request_trip(10)
      }.must_raise ArgumentError
    end

    it 'changes the status to unavailable for the driver selected' do
      @result.driver.status.must_equal :UNAVAILABLE
    end

    it 'adds the new trip to the collection of all trips' do
      @dispatcher.trips.must_include @result

      trips_length = @dispatcher.trips.length
      expected_new_trips_length = trips_length + 1
      @dispatcher.request_trip(5)
      @dispatcher.trips.length.must_equal expected_new_trips_length
    end

  end
  describe 'driver_selection' do

    before do
      @dispatcher = RideShare::TripDispatcher.new
    end
      # Driver 14: Antwan Prosacco (last trip 267 ended 2015-04-23T17:53:00+00:00)
      # Driver 27: Nicholas Larkin (last trip 468 ended 2015-04-28T04:13:00+00:00)
      # Driver 6: Mr. Hyman Wolf (last trip 295 ended 2015-08-14T09:54:00+00:00)
      # Driver 87: Jannie Lubowitz (last trip 73 ended 2015-10-26T01:13:00+00:00)
      # Driver 75: Mohammed Barrows (last trip 184 ended 2016-04-01T16:26:00+00:00)
    it 'selects the correct available drivers' do

      @result_1 = @dispatcher.request_trip(11)
      @result_2 = @dispatcher.request_trip(12)
      @result_3 = @dispatcher.request_trip(13)
      @result_4 = @dispatcher.request_trip(14)
      @result_5 = @dispatcher.request_trip(15)

      @result_1.driver.id.must_equal 14
      @result_2.driver.id.must_equal 27
      @result_3.driver.id.must_equal 6
      @result_4.driver.id.must_equal 87
      @result_5.driver.id.must_equal 75

    end
  end

end
