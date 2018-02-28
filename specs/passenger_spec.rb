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
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + (1500)
      trip = RideShare::Trip.new({id: 8, driver: nil, passenger: @passenger, start_time: start_time,end_time:end_time, rating: 5})

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

  describe "total_amount_spent" do
    #no trips, multiple trips tests include these!
    it "can return the total amount spent on rides per passenger" do
      passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")
      driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + (1500)

      trip = RideShare::Trip.new({id: 8, driver: driver, passenger: passenger, start_time: start_time, end_time:end_time ,rating: 5,cost:10})

      passenger.add_trip(trip)
      passenger.total_amount_spent.must_equal 250

    end
  end

  describe "total_amount_time" do
    it "can return the total amount of time spend on a ride" do
      a_trip = RideShare::Trip.new({id:12345,driver:"A driver",passenger:"a passenger",start_time:0,end_time:60,cost:10,rating:4})
      a_passenger = RideShare::Passenger.new({id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723", trips: [a_trip]})
      a_passenger.total_amount_time.must_equal 1
    end
  end

  describe "get_drivers method" do
    before do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")
      driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + (1500)

      trip = RideShare::Trip.new({id: 8, driver: driver, passenger: @passenger, start_time: start_time, end_time:end_time ,rating: 5})

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
end
