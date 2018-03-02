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
  end

  describe "trips property" do
    before do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723", trips: [])
      trip = RideShare::Trip.new({id: 8, driver: nil, passenger: @passenger, date: "2016-08-08", rating: 5})

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
  end

  describe "get_drivers method" do
    before do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")
      driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
      trip = RideShare::Trip.new({id: 8, driver: driver, passenger: @passenger, date: "2016-08-08", rating: 5})

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
  end

  describe "total_cost method" do
    before do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")
    end

    it "returns a number" do
      @passenger.must_respond_to :total_cost
      @passenger.total_cost.must_be_kind_of Float
    end

    it "returns zero if the passenger has no trips" do
      @passenger.total_cost.must_equal 0.0
    end

    it "returns the sum cost of the passenger's trips" do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")
      driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
      trip_1 = RideShare::Trip.new({id: 8, driver: driver, passenger: @passenger, start_time: Time.parse('2015-05-20T12:14:00+00:00'), end_time: Time.parse('2015-05-20T12:14:10+00:00'), cost: 10.15, rating: 3})
      trip_2 = RideShare::Trip.new({id: 8, driver: driver, passenger: @passenger, start_time: Time.parse('2015-05-20T12:14:00+00:00'), end_time: Time.parse('2015-05-20T12:14:08+00:00'), cost: 7, rating: 5})
      @passenger.add_trip(trip_1)
      @passenger.add_trip(trip_2)

      @passenger.total_cost.must_equal 17.15
    end
  end

  describe "total_time method" do
    before do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")
    end

    it "returns a number" do
      @passenger.must_respond_to :total_time
      @passenger.total_time.must_be_kind_of Float
    end

    it "returns zero if the passenger has no trips" do
      @passenger.total_time.must_equal 0.0
    end

    it "returns the sum duration of the passenger's trips" do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")
      driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
      trip_1 = RideShare::Trip.new({id: 8, driver: driver, passenger: @passenger, start_time: Time.parse("2016-04-05T14:01:00+00:00"), end_time: Time.parse("2016-04-05T14:09:00+00:00"), rating: 3})
      trip_2 = RideShare::Trip.new({id: 8, driver: driver, passenger: @passenger, start_time: Time.parse("2016-01-13T13:16:00+00:00"), end_time: Time.parse("2016-01-13T13:28:00+00:00"), rating: 5})
      @passenger.add_trip(trip_1)
      @passenger.total_time.must_equal 480
      @passenger.add_trip(trip_2)
      @passenger.total_time.must_equal 1200
    end
  end

  describe "completed_trips method" do
    before do
      @dispatcher = RideShare::TripDispatcher.new
      @passenger_1 = @dispatcher.find_passenger(1)
    end

    it "returns an array of trips" do
      @passenger_1.completed_trips.must_be_kind_of Array
      @passenger_1.completed_trips.each do |trip|
        trip.must_be_instance_of RideShare::Trip
      end
    end

    it "does not include incomplete trips" do
      new_trip = @dispatcher.request_trip(1)
      @passenger_1.trips.must_include new_trip
      @passenger_1.completed_trips.wont_include new_trip
    end

    it "returns an empty array if the passenger has no trips" do
      new_passenger = RideShare::Passenger.new(id: 301, name: "Caroline Nardi", phone: "1-602-620-2330")
      new_passenger.completed_trips.must_be_kind_of Array
      new_passenger.completed_trips.must_be_empty
    end
  end
end
