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

    it "stores start and end times as instances of Time" do
      @trip.start_time.must_be_instance_of Time
      @trip.end_time.must_be_instance_of Time
    end

    it "raises an error for invalid start and end times" do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time - 25 * 60 # negative - 25 minutes before start
      trip_data = {
        id: 8,
        driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3
      }
      # @trip = RideShare::Trip.new(@trip_data)

      proc {trip = RideShare::Trip.new(trip_data)}.must_raise ArgumentError
    end
  end

  describe 'trip_duration method'do
  it "returns the duration of a trip" do
    start_time = Time.parse("2016-01-13T13:16:00+00:00")
    end_time = Time.parse("2016-01-13T13:28:00+00:00")
    trip_data = {rating: 3, start_time: start_time , end_time: end_time}

    trip = RideShare::Trip.new(trip_data)

    trip.trip_duration.must_equal 720
  end
end
end
