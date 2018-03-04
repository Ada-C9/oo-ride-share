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

    it "raises an error for invalid end time" do
      @trip_data[:start_time] = Time.parse("2015-05-20T12:14:00+00:00")
      @trip_data[:end_time] = Time.parse("2015-05-20T12:13:00+00:00")
      # if @trip_data[:start_time] > @trip_data[:end_time]
      proc {
        RideShare::Trip.new(@trip_data)
      }.must_raise ArgumentError
      # end
    end
  end
  describe "duration" do
    it "calculate the duration of the trip in seconds" do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 30 * 60
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
      @trip.duration.must_equal 1800
    end

    it "calculate the duration of the trip in seconds when the end time is nil" do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = nil
      @trip_data = {
        id: 8,
        driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: start_time,
        end_time: end_time,
        cost: nil,
        rating: nil
      }
      @trip = RideShare::Trip.new(@trip_data)
      @trip.duration.must_equal nil
    end

    describe "finish_trip!" do
      it "change the end time" do
        start_time = Time.parse('2015-05-20T12:14:00+00:00')
        end_time = nil
        @trip_data = {
          id: 8,
          driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
          passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
          start_time: start_time,
          end_time: end_time,
          cost: nil,
          rating: nil
        }
        @trip = RideShare::Trip.new(@trip_data)
        @trip.finish_trip!
        @trip.end_time.to_i.must_equal Time.now.to_i
      end

      it "should raise an error when we try to finish trip that already finished" do
        start_time = Time.parse('2015-05-20T12:14:00+00:00')
        end_time = nil
        @trip_data = {
          id: 8,
          driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
          passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
          start_time: start_time,
          end_time: end_time,
          cost: nil,
          rating: nil
        }
        @trip = RideShare::Trip.new(@trip_data)
        @trip.finish_trip!

        proc {
          @trip.finish_trip!
        }.must_raise StandardError

      end
    end

    describe "finished?" do
      it "return true if the trip already finished and false if not" do
        start_time = Time.parse('2015-05-20T12:14:00+00:00')
        end_time = nil
        @trip_data = {
          id: 8,
          driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
          passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
          start_time: start_time,
          end_time: end_time,
          cost: nil,
          rating: nil
        }
        @trip = RideShare::Trip.new(@trip_data)
        @trip.finished?.must_equal false
        @trip.finish_trip!
        @trip.finished?.must_equal true
      end
    end
  end
end
