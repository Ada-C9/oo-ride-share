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

    it 'Store the start_time and end_time as Time instances' do
      dispatcher = RideShare::TripDispatcher.new
      trip = dispatcher.trips.first
      trip.start_time.must_be_instance_of Time

    end
  end

  describe '#request_trip' do

    before do
      @trip_disp = RideShare::TripDispatcher.new()
      # Request new trip:
      @new_trip = @trip_disp.request_trip(1)
    end

    it 'Creates a new instance of trips' do
      @new_trip.must_be_instance_of RideShare::Trip
      @new_trip.driver.must_be_instance_of RideShare::Driver
      @new_trip.passenger.must_be_instance_of RideShare::Passenger
    end

    it 'Updates the length of trip list in @trip_dispatcher:' do
      initial_list_length = @trip_disp.trips.length

      # Request new trip:
      @trip_disp.request_trip(1)

      final_list_length = @trip_disp.trips.length

      final_list_length.must_equal initial_list_length + 1
    end

    it 'Can find new trip in the trip list in @trip_dispatcher' do
      exists = false
      @trip_disp.trips.each{ |trip| exists = true if trip == @new_trip}

      exists.must_equal true
    end

    it 'Updates the drivers trip list:' do

      driver_for_new_trip = @new_trip.driver

      find_new_trip_in_driver = driver_for_new_trip.trips.find{ |trip|  trip == @new_trip }

      find_new_trip_in_driver.must_equal @new_trip
    end

    it 'Updates the passangers trip list:' do

      passenger_for_new_trip = @new_trip.passenger

      find_new_trip_in_passanger = passenger_for_new_trip.trips.find{ |trip|  trip == @new_trip }

      find_new_trip_in_passanger.must_equal @new_trip
    end

    it 'Selects an AVAILABLE driver' do

      initial_drivers_list = @trip_disp.load_drivers

      # Find the status for this driver in the initial list from file:
      index = @new_trip.driver.id - 1
      initial_status = initial_drivers_list[index].status

      # Assert:
      initial_status.must_equal :AVAILABLE
    end

    it 'Returns an exeption if there are no AVAILABLE drivers' do

      @trip_disp.drivers.each {|driver| driver.change_status}

      proc {@trip_disp.request_trip(1)}.must_raise StandardError
    end
  end

  describe 'wave3_request_trip' do
    before do
      @trip_disp = RideShare::TripDispatcher.new()
      # Request new trip:
      @new_trip = @trip_disp.wave3_request_trip(1)
    end

    it 'Creates a new instance of trips' do
      @new_trip.must_be_instance_of RideShare::Trip
      @new_trip.driver.must_be_instance_of RideShare::Driver
      @new_trip.passenger.must_be_instance_of RideShare::Passenger
    end
    
    it "Selects the right driver for the first 5 new trip-requests" do

      # 1 - Arrange / Act:
      driver1_id = 100
      driver1_name = "Minnie Dach"
      new_trip1 = @new_trip
      test_driver1 = new_trip1.driver
      # Assert:
      test_driver1.must_be_instance_of RideShare::Driver
      test_driver1.id.must_equal driver1_id
      test_driver1.name.must_equal driver1_name

      # 2 - Arrange / Act:
      new_trip2 = @trip_disp.wave3_request_trip(2)
      driver2_id = 14
      driver2_name = "Antwan Prosacco"
      test_driver2 = new_trip2.driver
      # Assert:
      test_driver2.must_be_instance_of RideShare::Driver
      test_driver2.id.must_equal driver2_id
      test_driver2.name.must_equal driver2_name

      # 3 - Arrange / Act:
      new_trip3 = @trip_disp.wave3_request_trip(4)
      driver3_id = 27
      driver3_name = "Nicholas Larkin"
      test_driver3 = new_trip3.driver
      # Assert:
      test_driver3.must_be_instance_of RideShare::Driver
      test_driver3.id.must_equal driver3_id
      test_driver3.name.must_equal driver3_name

      # 4 - Arrange / Act:
      new_trip4 = @trip_disp.wave3_request_trip(52)
      driver4_id = 6
      driver4_name = "Mr. Hyman Wolf"
      test_driver4 = new_trip4.driver
      # Assert:
      test_driver4.must_be_instance_of RideShare::Driver
      test_driver4.id.must_equal driver4_id
      test_driver4.name.must_equal driver4_name

      # 5 - Arrange / Act:
      new_trip5 = @trip_disp.wave3_request_trip(61)
      driver5_id = 87
      driver5_name = "Jannie Lubowitz"
      test_driver5 = new_trip5.driver
      # Assert:
      test_driver5.must_be_instance_of RideShare::Driver
      test_driver5.id.must_equal driver5_id
      test_driver5.name.must_equal driver5_name
    end

    it 'Selects an AVAILABLE driver' do

      initial_drivers_list = @trip_disp.load_drivers

      # Find the status for this driver in the initial list from file:
      index = @new_trip.driver.id - 1
      initial_status = initial_drivers_list[index].status

      # Assert:
      initial_drivers_list[0].must_be_instance_of RideShare::Driver
      initial_status.must_equal :AVAILABLE
    end

    it 'Returns an error if there are no AVAILABLE drivers' do
      @trip_disp.drivers.each {|driver| driver.change_status}
      # Assert:
      proc {@trip_disp.wave3_request_trip(1)}.must_raise StandardError
    end

    it 'Updates the length of trip list in @trip_disp:' do
      initial_list_length = @trip_disp.trips.length

      # Request new trip:
      @trip_disp.wave3_request_trip(1)

      final_list_length = @trip_disp.trips.length

      # Assert:
      final_list_length.must_equal initial_list_length + 1
    end

    it 'Can find new trip in the trip list in @trip_disp' do
      exists = false
      @trip_disp.trips.each {|trip| exists = true if trip == @new_trip}

      exists.must_equal true
    end

    it 'Updates the drivers trip list:' do
      # Look for new trip in the trips list:
      driver_for_new_trip = @new_trip.driver

      find_new_trip_in_driver = driver_for_new_trip.trips.find{ |trip|  trip == @new_trip }

      #Assert:
      find_new_trip_in_driver.must_be_instance_of RideShare::Trip
      driver_for_new_trip.must_be_instance_of RideShare::Driver
      find_new_trip_in_driver.must_equal @new_trip
    end

    it 'Updates the passangers trip list:' do
      passenger_for_new_trip = @new_trip.passenger

      find_new_trip_in_passanger = passenger_for_new_trip.trips.find{ |trip|  trip == @new_trip }

      find_new_trip_in_passanger.must_be_instance_of RideShare::Trip
      passenger_for_new_trip.must_be_instance_of RideShare::Passenger
      find_new_trip_in_passanger.must_equal @new_trip
    end
  end

  ##_________Personal tests for some methods that became private when refactoring:
  #
  # describe 'select_driver_available' do
  #   it 'Selects an AVAILABLE driver' do
  #
  #     @trip_disp = RideShare::TripDispatcher.new()
  #     # Request new trip:
  #     @new_trip = @trip_disp.request_trip(1)
  #
  #     initial_drivers_list = @trip_disp.load_drivers
  #     # Find the status for this driver in the initial list from file:
  #
  #     index = @new_trip.driver.id - 1
  #     initial_status = initial_drivers_list[index].status
  #
  #     # Assert:
  #     initial_status.must_equal :AVAILABLE
  #   end
  # end
  #
  # describe 'select_the_right_driver' do
  #
  #   it 'selects the right driver for the first new trip requested' do
  #     trip_dispatcher = RideShare::TripDispatcher.new()
  #
  #     driver1_id = 100
  #     driver1_name = "Minnie Dach"
  #     test_driver1 = trip_dispatcher.select_the_right_driver
  #
  #     test_driver1.id.must_equal driver1_id
  #     test_driver1.name.must_equal driver1_name
  #   end
  # end

end
