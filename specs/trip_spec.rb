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
    # **W1: TEST FOR RAISING AN ERROR IF END TIME IS BEFORE START TIME--------------
    it "raises an error if the end time is before the start time" do
      trip_info = {
        id: 1,
        driver: "Jo Baker",
        passenger: "Etta James",
        start_time: Time.parse("2016-04-05T14:02:00+00:00"),
        end_time: Time.parse("2016-04-05T14:01:00+00:00"),
        cost: 28.16,
        rating: 4}

        proc {
          RideShare::Trip.new(trip_info)
        }.must_raise ArgumentError
      end
      # **W1: TEST FOR RAISING AN ERROR IF END TIME IS BEFORE START TIME--------------
    end

    describe "duration" do
      it "can calculate the duration of a trip in seconds" do
        e_time = Time.parse("2016-04-05T14:00:00+00:00")
        s_time = Time.parse("2016-04-05T13:00:00+00:00")
        # CALLING AN KEY ARGUMENT,SINCE ALL THE ATTRIBUTES WERE STORED AS SUCH
        trip_info = {rating: 3, end_time: e_time, start_time: s_time}

        # Act-----------------
        # Assert------------
        trip = RideShare::Trip.new(trip_info)
        trip.duration.must_equal 3600
      end
    end
  end
