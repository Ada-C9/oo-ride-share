require_relative 'spec_helper'

describe "Trip class" do

  describe "initialize" do
    before do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      @trip_data = {
        id: 8,
        driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3
      }
      @trip = RideShare::Trip.new(@trip_data)
    end

    it "is an instance of Trip" do
      @trip.must_be_kind_of RideShare::Trip
    end

    it "stores an instance of passenger" do
      @trip.passenger.must_be_kind_of RideShare::Passenger
    end

    it "stores an instance of driver" do
      @trip.driver.must_be_kind_of RideShare::Driver
    end

    it "raises an error for an invalid rating" do
      [-3, 0, 6].each do |rating|
        @trip_data[:rating] = rating
        proc {
          RideShare::Trip.new(@trip_data)
        }.must_raise ArgumentError
      end
    end

    it 'Raises an ArgumentError if the end time is before the start time' do

      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time - 25 * 60 # - 25 minutes

      @trip_data = {
        id: 8,
        driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3
      }

      proc {RideShare::Trip.new(@trip_data)}.must_raise ArgumentError
    end
  end

  describe '#duration_method' do
    it 'calculate the duration of the trip in seconds' do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 1 * 60 # + 1 minute

      @trip_data = {
        id: 8,
        driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3
      }
      @trip = RideShare::Trip.new(@trip_data)

      @trip.duration_method.must_equal 60

    end
  end

  describe '#request_trip' do
    it 'Updates the trip list in trip_dispatcher:' do
      trip_disp = RideShare::TripDispatcher.new()
      initial_list_length = trip_disp.trips.length

      # Request new trip:
      trip_disp.request_trip(1)

      final_list_length = trip_disp.trips.length

      final_list_length.must_equal initial_list_length + 1
    end

    it 'Updates the driver s trip list:' do
      trip_disp = RideShare::TripDispatcher.new()

      # Request new trip:
      new_trip = trip_disp.request_trip(1)

      driver_for_new_trip = new_trip.driver

      find_new_trip_in_driver = driver_for_new_trip.trips.find{ |trip|  trip == new_trip }

      find_new_trip_in_driver.must_equal new_trip

      # maybe do this too!:
      # final_driver_list_length = driver_for_new_trip.trips.length
      #
      # final_driver_list_length.must_equal initial_driver_list_length + 1
    end

    it 'Updates the passanger s trip list:' do
      trip_disp = RideShare::TripDispatcher.new()

      # Request new trip:
      new_trip = trip_disp.request_trip(1)

      passenger_for_new_trip = new_trip.passenger

      find_new_trip_in_passanger = passenger_for_new_trip.trips.find{ |trip|  trip == new_trip }

      find_new_trip_in_passanger.must_equal new_trip

    end

  end

end



# Was the trip created properly?
# Were the trip lists for the driver and passenger updated?
# Was the driver who was selected AVAILABLE?
# What happens if you try to request a trip when there are no AVAILABLE drivers?
