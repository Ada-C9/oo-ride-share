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

    it "001 is an instance of Trip" do
      @trip.must_be_kind_of RideShare::Trip
    end

    it "002 stores an instance of passenger" do
      @trip.passenger.must_be_kind_of RideShare::Passenger
    end

    it "003 stores an instance of driver" do
      @trip.driver.must_be_kind_of RideShare::Driver
    end

    #driver also does this,
    it "004 raises an error for an invalid rating" do
      [-3, 0, 6].each do |rating|
        @trip_data[:rating] = rating
        proc {
          RideShare::Trip.new(@trip_data)
        }.must_raise ArgumentError
      end
    end

    it "005 returns an error if start time is after end time" do
      @trip_data[:end_time] = @trip_data[:start_time] -25 * 60 # 25 minutes
      proc {
        RideShare::Trip.new(@trip_data)
      }.must_raise ArgumentError
    end

    it "0006 returns a duration of trip time" do
      @trip.length.must_equal 1500

    end

  end
end
