require_relative 'spec_helper'

describe "RideShare Method class" do

  describe "return_valid_id_or_error" do

    it "throws an argument error with a bad ID value" do
      proc{ RideShare.return_valid_id_or_error(0) }.must_raise ArgumentError
      proc{ RideShare.return_valid_id_or_error("foo") }.must_raise ArgumentError
    end

    it "returns a valid id" do
      RideShare.return_valid_id_or_error(1).must_equal 1
    end

  end

  describe "return_valid_name_or_error" do

    it "throws an argument error with a bad name value" do
      proc{ RideShare.return_valid_name_or_error("") }.must_raise ArgumentError
      proc{ RideShare.return_valid_name_or_error(" ") }.must_raise ArgumentError
      proc{ RideShare.return_valid_name_or_error(42) }.must_raise ArgumentError
    end

    it "returns a valid name" do
      RideShare.return_valid_name_or_error("Ada").must_equal "Ada"
    end

  end

  describe "return_valid_driver_or_error" do

    it "throws an argument error with a bad driver value" do
      proc{ RideShare.return_valid_driver_or_error(42) }.must_raise ArgumentError
    end

    it "returns a valid name" do
      driver = RideShare::Driver.new(id: 42, name: "George",
        vin: "33133313331333133")
      RideShare.return_valid_driver_or_error(driver).must_equal driver
    end

  end

  describe "return_valid_trip_or_error" do

    it "throws an argument error with a bad trip value" do
      proc{ RideShare.return_valid_trip_or_error(42) }.must_raise ArgumentError
    end

    it "returns a valid trip" do
      pass = RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640")
      driver = RideShare::Driver.new(id: 3, name: "Lovelace",
        vin: "12345678912345678")
      trip = RideShare::Trip.new({id: 8, driver: driver, passenger: pass,
        start_time: Time.parse("2018-01-02T10:42:00+00:00"),
        end_time: Time.parse("2018-01-02T11:42:00+00:00"),
        rating: 5})

      RideShare.return_valid_trip_or_error(trip).must_equal trip
    end

  end

  describe "return_valid_trips_or_errors" do

    before do
      pass = RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640")
      driver = RideShare::Driver.new(id: 3, name: "Lovelace",
        vin: "12345678912345678")
      @trip = RideShare::Trip.new({id: 8, driver: driver, passenger: pass,
        start_time: Time.parse("2018-01-02T10:42:00+00:00"),
        end_time: Time.parse("2018-01-02T11:42:00+00:00"),
        rating: 5})
    end

    it "throws an argument error with a bad trips value" do
      proc{ RideShare.return_valid_trips_or_errors(42) }.must_raise ArgumentError
      proc{ RideShare.return_valid_trips_or_errors(["foo"])
        }.must_raise ArgumentError
      proc{ RideShare.return_valid_trips_or_errors([@trip, "foo"])
        }.must_raise ArgumentError
      proc{ RideShare.return_valid_trips_or_errors(@trip)
        }.must_raise ArgumentError
    end

    it "returns a valid trip array" do
      pass_two = RideShare::Passenger.new(id: 19, name: "Ada TWo",
        phone: "412-432-7640")
      driver_two = RideShare::Driver.new(id: 33, name: "Lovelace Two",
        vin: "1234567891q345678")
      trip_two = RideShare::Trip.new({id: 95, driver: driver_two,
        passenger: pass_two, start_time: Time.parse("2018-01-03T10:42:00+00:00"),
        end_time: Time.parse("2018-01-03T11:42:00+00:00"),
        rating: 5})

      trips = [@trip, trip_two]

      RideShare.return_valid_trips_or_errors(trips).must_equal trips
    end

    it "returns an empty array if nil" do
      RideShare.return_valid_trips_or_errors(nil).must_equal []
    end

  end


  describe "get_all_trip_durations_in_seconds" do

    before do
      pass = RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640")
      driver = RideShare::Driver.new(id: 3, name: "Lovelace",
        vin: "12345678912345678")

      @trip = RideShare::Trip.new({id: 8, driver: driver, passenger: pass,
        start_time: Time.parse("2018-01-02T10:42:00+00:00"),
        end_time: Time.parse("2018-01-02T11:42:00+00:00"),
        rating: 5})

      @trip_two = RideShare::Trip.new({id: 95, driver: driver, passenger: pass,
          start_time: Time.parse("2018-01-03T10:00:00+00:00"),
          end_time: Time.parse("2018-01-03T10:20:00+00:00"),
          rating: 5})

      @trip_three = RideShare::Trip.new({id: 99, driver: driver, passenger: pass,
          start_time: Time.parse("2018-01-04T11:00:00+00:00")})
    end

    it "throws an error for invalid trips array" do
      proc{ RideShare.get_all_trip_durations_in_seconds(["foo"]) }.must_raise ArgumentError
      proc{ RideShare.get_all_trip_durations_in_seconds(@trip) }.must_raise ArgumentError
    end

    it "calculates trip duration in seconds" do
      duration = RideShare.get_all_trip_durations_in_seconds([@trip, @trip_two])
      duration.must_equal 4800
    end

    it "ignores in-progress trips" do
      duration = RideShare.get_all_trip_durations_in_seconds([@trip, @trip_two,
         @trip_three])
      duration.must_equal 4800
    end

    it "returns 'nil' if no completed trips" do
      RideShare.get_all_trip_durations_in_seconds([]).must_equal 0
      RideShare.get_all_trip_durations_in_seconds([@trip_three]).must_equal 0
    end

  end

end
