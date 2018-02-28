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
      start_time = Time.parse("2016-04-05T14:01:00+00:00")
      end_time = Time.parse("2016-04-05T14:05:00+00:00")
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
  end

  describe "get_drivers method" do
    before do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")
      driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
      start_time = Time.parse("2016-04-05T14:01:00+00:00")
      end_time = Time.parse("2016-04-05T14:05:00+00:00")
      trip = RideShare::Trip.new({id: 8, driver: driver, passenger: @passenger, cost: 20.00, start_time: start_time, end_time: end_time, rating: 5})

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

  describe "total_spend" do
    it "accurately returns the total for a specific passenger's trips" do
      trips = [
        RideShare::Trip.new({cost: 10.00, rating: 3}),
        RideShare::Trip.new({cost: 10.00, rating: 3}),
        RideShare::Trip.new({cost: 10.00, rating: 3})
      ]
      passenger_data = {
        id: 7,
        name: 'Speed Passenger',
        phone_number: '555.555.5555',
        trips: trips
      }
      passenger = RideShare::Passenger.new(passenger_data)
      passenger.total_spend.must_equal(30.00)
    end
  end

  describe "total_ride_time_minutes" do
    before do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")
      driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
      start_time = Time.parse("2016-04-05T14:01:00+00:00")
      end_time = Time.parse("2016-04-05T14:05:00+00:00")
      trip = RideShare::Trip.new({id: 8, driver: driver, passenger: @passenger, cost: 20.00, start_time: start_time, end_time: end_time, rating: 5})

      @passenger.add_trip(trip)
    end

    it "accurately returns the total amount of time a passenger has spent on their trips" do
      @passenger.total_ride_time_minutes.must_equal(4)
    end
  end

end
