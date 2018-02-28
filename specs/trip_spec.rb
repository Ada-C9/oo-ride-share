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

    it "stores an instanxce of driver" do
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

    it "raises an error when the end time is before the start time" do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time - 25 * 60 # 25 minutes before start
      @trip_data[:start_time] = start_time
      @trip_data[:end_time] = end_time
      proc {
        RideShare::Trip.new(@trip_data)
      }.must_raise ArgumentError
     end

     it "returns nil if start_time/end_time unavailable" do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = nil
      @trip_data[:start_time] = start_time
      @trip_data[:end_time] = end_time
      @trip = RideShare::Trip.new(@trip_data)

      @trip.get_duration.must_equal nil
     end

    it "calculates the duration of the trip in seconds when short time" do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      @trip_data[:start_time] = start_time
      @trip_data[:end_time] = end_time
      @trip = RideShare::Trip.new(@trip_data)

      @trip.get_duration.must_equal 1500
    end

    it "calculates the duration of the trip in seconds when long time" do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 600 * 60 # 10 hours
      @trip_data[:start_time] = start_time
      @trip_data[:end_time] = end_time
      @trip = RideShare::Trip.new(@trip_data)

      @trip.get_duration.must_equal 36000
    end

  end
end
