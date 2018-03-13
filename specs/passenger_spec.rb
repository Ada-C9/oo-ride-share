require 'time'
require_relative 'spec_helper'

describe "Passenger class" do


  before do

  @passenger_a = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")
  driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")

  trip_1 = RideShare::Trip.new({id: 8, driver: driver, passenger: @passenger_a, start_time: Time.parse('2016-08-08T16:01:00+00:00'), end_time: Time.parse('2016-08-08T16:37:00+00:00'), cost: 10.12, rating: 5})

  trip_2 = RideShare::Trip.new({id: 9, driver: driver, passenger: @passenger_a, start_time: Time.parse('2016-09-08T16:01:00+00:00'), end_time: Time.parse('2016-09-08T16:38:00+00:00'), cost: 10.13, rating: 5})

  trip_3 = RideShare::Trip.new({id: 10, driver: driver, passenger: @passenger_a, start_time: Time.parse('2016-10-08T16:01:00+00:00'), end_time: Time.parse('2016-10-08T16:39:00+00:00'), cost: 10.14, rating: 5})

  @passenger_a.add_trip(trip_1)
  @passenger_a.add_trip(trip_2)
  @passenger_a.add_trip(trip_3)

  @newly_requested_trip = RideShare::Trip.new({id: 10, driver: "Meret Oppenheim", passenger: @passenger_a, start_time: Time.now, end_time: nil, cost: nil, rating: nil})

  end

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
      trip = RideShare::Trip.new({id: 8, driver: nil, passenger: @passenger, start_time: Time.parse('2016-08-08T16:01:00+00:00'), end_time: Time.parse('2016-08-08T16:37:00+00:00'), cost: 10.12, rating: 5})

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

      trip = RideShare::Trip.new({id: 8, driver: driver, passenger: @passenger, start_time: Time.parse('2016-08-08T16:01:00+00:00'), end_time: Time.parse('2016-08-08T16:37:00+00:00'), cost: 10.12, rating: 5})

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

  describe "log_newly_reqested_trip(trip)" do
    before do
      @passenger_a.log_newly_requested_trip(@newly_requested_trip)
    end

    it "adds the requested trip to the passenger's collection" do
      @passenger_a.trips.count.must_equal 4
      @passenger_a.trips.must_include @newly_requested_trip
    end
  end

  describe "total_ride_time" do

    it "returns an accurate tally of the passenger's ride-times" do

      total_trip_seconds = @passenger_a.total_ride_time
      total_trip_seconds.must_equal 6660

    end

    it "functions properly if a passenger has a ride in progress" do
      @passenger_a.add_trip(@newly_requested_trip)
      total_trip_seconds = @passenger_a.total_ride_time
      total_trip_seconds.must_equal 6660
    end
  end

  describe "total_spent" do

    it "returns an accurate tally of the passenger's payments" do

      passenger_total_paid = @passenger_a.total_spent
      passenger_total_paid.must_equal 30.39

    end

    it "functions properly if a passenger has a ride in progress" do

      @passenger_a.add_trip(@newly_requested_trip)
      passenger_total_paid = @passenger_a.total_spent
      passenger_total_paid.must_equal 30.39
    end
  end
end
