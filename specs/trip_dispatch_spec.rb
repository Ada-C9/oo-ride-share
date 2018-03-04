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

  describe 'select_driver_available' do
    it 'Selects an AVAILABLE driver' do

      @trip_disp = RideShare::TripDispatcher.new()
      # Request new trip:
      @new_trip = @trip_disp.request_trip(1)

      initial_drivers_list = @trip_disp.load_drivers
      # Find the status for this driver in the initial list from file:

      index = @new_trip.driver.id - 1
      initial_status = initial_drivers_list[index].status

      # Assert:
      initial_status.must_equal :AVAILABLE
    end
  end

  describe '#request_trip' do

    before do
      @trip_disp = RideShare::TripDispatcher.new()
      # Request new trip:
      @new_trip = @trip_disp.request_trip(1)
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

      # maybe do this too!:
      # final_driver_list_length = driver_for_@new_trip.trips.length
      #
      # final_driver_list_length.must_equal initial_driver_list_length + 1
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

  describe 'select_the_right_driver' do

    it 'selects' do
      trip_dispatcher = RideShare::TripDispatcher.new()

      driver1_id = 100
      driver1_name = "Minnie Dach"
      test_driver1 = trip_dispatcher.select_the_right_driver
      test_driver1.id.must_equal driver1_id
      test_driver1.name.must_equal driver1_name
      #
      # driver1_id = 14
      # driver1_name = "Antwan Prosacco "
      # test_driver1 = trip_dispatcher.select_the_right_driver
      # test_driver1.id.must_equal driver1_id
      # test_driver1.name.must_equal driver1_name
      #
      # driver1_id = 27
      # driver1_name = "Nicholas Larkin "
      # test_driver1 = trip_dispatcher.select_the_right_driver
      # test_driver1.id.must_equal driver1_id
      # test_driver1.name.must_equal driver1_name
      #
      # driver1_id = 6
      # driver1_name = "Mr. Hyman Wolf"
      # test_driver1 = trip_dispatcher.select_the_right_driver
      # test_driver1.id.must_equal driver1_id
      # test_driver1.name.must_equal driver1_name
      #
      # driver1_id = 87
      # driver1_name = "Jannie Lubowitz"
      # test_driver1 = trip_dispatcher.select_the_right_driver
      # test_driver1.id.must_equal driver1_id
      # test_driver1.name.must_equal driver1_name
    end
  end

  describe 'better_request_new_trip' do
    before do
      @trip_disp = RideShare::TripDispatcher.new()
      # Request new trip:
      @new_trip = @trip_disp.better_request_new_trip(1)
    end

    it "Selects the right driver" do

      driver1_id = 100
      driver1_name = "Minnie Dach"
      new_trip1 = @new_trip
      test_driver1 = new_trip1.driver
      test_driver1.id.must_equal driver1_id
      test_driver1.name.must_equal driver1_name

      new_trip2 = @trip_disp.better_request_new_trip(2)
      driver2_id = 14
      driver2_name = "Antwan Prosacco"
      test_driver2 = new_trip2.driver
      test_driver2.id.must_equal driver2_id
      test_driver2.name.must_equal driver2_name

      new_trip3 = @trip_disp.better_request_new_trip(4)
      driver3_id = 27
      driver3_name = "Nicholas Larkin"
      test_driver3 = new_trip3.driver
      test_driver3.id.must_equal driver3_id
      test_driver3.name.must_equal driver3_name

      driver4_id = 6
      driver4_name = "Mr. Hyman Wolf"
      test_driver4 = @trip_disp.better_request_new_trip(1).driver
      test_driver4.id.must_equal driver4_id
      test_driver4.name.must_equal driver4_name

      driver4_id = 87
      driver4_name = "Jannie Lubowitz"
      test_driver4 = @trip_disp.better_request_new_trip(1).driver
      test_driver4.id.must_equal driver4_id
      test_driver4.name.must_equal driver4_name
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
      proc {@trip_disp.better_request_new_trip(1)}.must_raise StandardError
    end

    it 'Updates the length of trip list in @trip_disp:' do
      initial_list_length = @trip_disp.trips.length

      # Request new trip:
      @trip_disp.better_request_new_trip(1)

      final_list_length = @trip_disp.trips.length
      # puts "initial_list_length = #{initial_list_length}"
      # puts "final_list_length = #{final_list_length}"
      final_list_length.must_equal initial_list_length + 1
    end

    it 'Can find new trip in the trip list in @trip_disp' do
      exists = false
      @trip_disp.trips.each{ |trip| exists = true if trip == @new_trip}

      exists.must_equal true
    end

    it 'Updates the drivers trip list:' do

      # Look for new trip in the trips list:
      driver_for_new_trip = @new_trip.driver


      find_new_trip_in_driver = driver_for_new_trip.trips.find{ |trip|  trip == @new_trip }

      find_new_trip_in_driver.must_equal @new_trip

      # # __________________________________Erase this
      # # Compare length of original and new trips list of the driver:
      #
      # drivers_trips_new_length = driver_for_new_trip.trips.length
      #
      #
      # my_file = CSV.open('support/drivers.csv', headers: true)
      #
      # all_drivers = []
      # my_file.each do |line|
      #   input_data = {}
      #   # Set to a default value
      #   vin = line[2].length == 17 ? line[2] : "0" * 17
      #
      #   # Status logic
      #   status = line[3]
      #   status = status.to_sym
      #
      #   input_data[:vin] = vin
      #   input_data[:id] = line[0].to_i
      #   input_data[:name] = line[1]
      #   input_data[:status] = status
      #   all_drivers << input_data
      # end
      #
      # this_driver = all_drivers.each {|driver| return driver if :id == driver_for_new_trip.id}
      #
      #
      #
      # trips = []
      # trip_data = CSV.open('support/trips.csv', 'r', headers: true, header_converters: :symbol)
      #
      # trip_data.each do |raw_trip|
      #   driver = all_drivers.each {|driver| return driver if :id == driver_for_new_trip.id}
      #   # passenger = find_passenger(raw_trip[:passenger_id].to_i)
      #
      #   # if driver.nil? || passanger.nil?
      #   #   raise "Could not find driver or passanger "
      #   # end
      #
      #   parsed_trip = {
      #     id: raw_trip[:id].to_i,
      #     driver: driver,
      #     # passenger: passenger,
      #     start_time: Time.parse(raw_trip[:start_time]),
      #     end_time: Time.parse(raw_trip[:end_time]),
      #     cost: raw_trip[:cost].to_f,
      #     rating: raw_trip[:rating].to_i
      #   }
      #
      #   trip = parsed_trip
      #   trips << trip
      # end
      #
      # drivers_trips = []
      # trips.each {|trip| drivers_trips << trip if :driver == this_driver}
      #
      # # this_driver = all_drivers.find_driver(driver_for_new_trip.id)
      #
      # drivers_trips_old_length = drivers_trips.length
      #
      #
      # drivers_trips_new_length.must_equal drivers_trips_old_length + 1


    end

    it 'Updates the passangers trip list:' do
      passenger_for_new_trip = @new_trip.passenger

      find_new_trip_in_passanger = passenger_for_new_trip.trips.find{ |trip|  trip == @new_trip }

      find_new_trip_in_passanger.must_equal @new_trip
    end
  end

end
