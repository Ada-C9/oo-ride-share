require_relative 'spec_helper'

describe "Trip class" do

  describe "initialize" do
    before do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes later
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

    it "raises an error for an invalid time entry" do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time - 25 * 60 # 25 minutes earlier
      trip_data = {
        id: 8,
        driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3
      }
      proc { RideShare::Trip.new(trip_data) }.must_raise ArgumentError
    end

    it "allows nil values for end_time, cost, and rating" do
      trip_data = {
        id: 8,
        driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: Time.parse('2015-05-20T12:14:00+00:00'),
        end_time: nil,
        cost: nil,
        rating: nil
      }
      trip = RideShare::Trip.new(trip_data)
      trip.must_be_instance_of RideShare::Trip
    end
  end

  describe "duration method" do
    it "returns an the difference between trip start and end times" do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 #25 minutes later
      trip_data = {
        id: 8,
        driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3
      }
      trip = RideShare::Trip.new(trip_data)

      trip.duration.must_be_kind_of Float
      trip.duration.must_equal 1500.0
    end

    it "returns zero if trip start and end times are the same" do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      trip_data = {
        id: 8,
        driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: start_time,
        end_time: start_time,
        cost: 23.45,
        rating: 3
      }
      trip = RideShare::Trip.new(trip_data)

      trip.duration.must_equal 0
    end

    it "returns zero if trip is not finished" do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      trip_data = {
        id: 8,
        driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: start_time,
        end_time: nil,
        cost: nil,
        rating: nil
      }
      trip = RideShare::Trip.new(trip_data)

      trip.duration.must_equal 0
    end
  end

  describe "finished_trip? method" do
    it "accurately reflects if a trip is not finished" do
      trip_data = {
        id: 8,
        driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: Time.parse('2015-05-20T12:14:00+00:00'),
        end_time: nil,
        cost: nil,
        rating: nil
      }
      trip = RideShare::Trip.new(trip_data)
      trip.is_finished?.must_equal false
    end

    it "accurately reflects if a trip is finished" do
      trip_data = {
        id: 8,
        driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: Time.parse('2015-05-20T12:14:00+00:00'),
        end_time: Time.parse('2015-05-20T12:14:00+00:00') + 25 * 60,
        cost: 12.34,
        rating: 4
      }
      trip = RideShare::Trip.new(trip_data)
      trip.is_finished?.must_equal true
    end
  end
end
