require_relative 'spec_helper'

describe "Trip class" do

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

  describe "initialize" do

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

    it "raises an error if the end time is before the start time" do

      start_time = Time.parse('2016-01-13T13:28:00+00:00')
      end_time = Time.parse('2016-01-13T13:16:00+00:00')

      trip_data = {
        id: 8,
        driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3
      }

      proc {RideShare::Trip.new(trip_data)}.must_raise ArgumentError

    end

    # it "raises an error if the end time is equal to the start time" do
    #
    #   start_time = Time.parse('2016-01-13T13:16:00+00:00')
    #   end_time = Time.parse('2016-01-13T13:16:00+00:00')
    #
    #   trip_data = {
    #     id: 8,
    #     driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
    #     passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
    #     start_time: start_time,
    #     end_time: end_time,
    #     cost: 23.45,
    #     rating: 3
    #   }
    #
    #   proc {RideShare::Trip.new(trip_data)}.must_raise ArgumentError
    #
    # end
  end

  describe "The Duration Method" do
    it "calculates the duration of a trip in seconds" do

      trip_length = @trip.duration
      trip_length.must_be_kind_of Float
      # Convert 25 min to sec
      trip_length.must_equal 1500.0

    end
  end

end
