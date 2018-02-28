  require_relative 'spec_helper'

  describe "Passenger class" do

    describe "Passenger instantiation" do
      before do
        @passenger = RideShare::Passenger.new({id: 1, name: "Smithy", phone: "353-533-5334"})
      end

      it "is an instance of Passenger" do
        @passenger.must_be_kind_of RideShare::Passenger
      end

      it "throws an argument error with a bad ID value" do
        proc{ RideShare::Passenger.new(id: 0, name: "Smithy")}.must_raise ArgumentError
      end

      it "sets trips to an empty array if not provided" do
        @passenger.trips.must_be_kind_of Array
        @passenger.trips.length.must_equal 0
      end

      it "is set up for specific attributes and data types" do
        [:id, :name, :phone_number, :trips].each do |prop|
          @passenger.must_respond_to prop
        end

        @passenger.id.must_be_kind_of Integer
        @passenger.name.must_be_kind_of String
        @passenger.phone_number.must_be_kind_of String
        @passenger.trips.must_be_kind_of Array
      end
    end # end of describe Passenger initiation


    describe "trips property" do
      before do
        @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723", trips: [])

        start_time = Time.parse("2015-05-27T01:11:00+00:00")
        end_time = Time.parse("2015-05-27T01:11:00+00:00")
        trip = RideShare::Trip.new({id: 8, driver: nil, passenger: @passenger, start_time: start_time, end_time: end_time, rating: 5})

        @passenger.add_trip(trip)
      end

      it "each item in array is a Trip instance" do
        @passenger.trips.each do |trip|
          trip.must_be_kind_of RideShare::Trip
        end
      end

      it "all Trips must have the same Passenger id" do
        @passenger.trips.each do |trip|
          trip.passenger.id.must_equal 9
        end
      end
    end # end of describe trips property

    describe "get_drivers method" do
      before do
        @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")

        driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")

        start_time = Time.parse("2017-02-08T08:22:00+00:00")
        end_time = Time.parse("2017-02-08T08:58:00+00:00")
        trip = RideShare::Trip.new({id: 8, driver: driver, passenger: @passenger, start_time: start_time, end_time: end_time, rating: 5})

        @passenger.add_trip(trip)
      end

      it "returns an array" do
        drivers = @passenger.get_drivers
        drivers.must_be_kind_of Array
        drivers.length.must_equal 1
      end

      it "all items in array are Driver instances" do
        @passenger.get_drivers.each do |driver|
          driver.must_be_kind_of RideShare::Driver
        end
      end
    end # end of describe get_drivers method

    describe "calculate_all_trips_cost method" do

      it "returns a the correct total" do
        @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723", trips: [])

        start_time = Time.parse("2015-05-27T01:11:00+00:00")
        end_time = Time.parse("2015-05-27T01:11:00+00:00")
        trip = RideShare::Trip.new({id: 8, driver: nil, passenger: @passenger, start_time: start_time, end_time: end_time, cost: 4.25, rating: 5})

        @passenger.add_trip(trip)

        start_time = Time.parse("2016-05-25T23:04:00+00:00")
        end_time = Time.parse("2016-05-25T23:49:00+00:00")
        trip1 = RideShare::Trip.new({id: 24, driver: nil, passenger: @passenger, start_time: start_time, end_time: end_time, cost: 23, rating: 5})

        @passenger.add_trip(trip1)

        @passenger.calculate_all_trips_cost.must_be_kind_of Float
        @passenger.calculate_all_trips_cost.must_equal 27.25
      end # end of returns a float

      it "returns 0 when no trips" do
        @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723", trips: [])
        @passenger.calculate_all_trips_cost.must_equal 0
      end
    end # end of describe calculate_all_trips_cost

    describe "calculate_total_trips_time" do
      before do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723", trips: [])

      start_time = Time.parse("2015-05-27T01:11:00+00:00")
      end_time = Time.parse("2015-05-27T01:11:00+00:00")
      trip = RideShare::Trip.new({id: 8, driver: nil, passenger: @passenger, start_time: start_time, end_time: end_time, cost: 4.25, rating: 5})

      @passenger.add_trip(trip)

      start_time = Time.parse("2016-05-25T23:04:00+00:00")
      end_time = Time.parse("2016-05-25T23:49:00+00:00")
      trip1 = RideShare::Trip.new({id: 24, driver: nil, passenger: @passenger, start_time: start_time, end_time: end_time, cost: 23, rating: 5})

      @passenger.add_trip(trip1)

      end

      it "" do

      end
    end # end of describe "calculate_total_trips_time"
  end # end of describe Passenger
