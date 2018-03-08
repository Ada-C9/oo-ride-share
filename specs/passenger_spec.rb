require_relative 'spec_helper'

describe "Passenger class" do

  describe "Passenger instantiation" do
    before do
      @passenger = RideShare::Passenger.new({id: 1, name: "Smithy", phone: "353-533-5334"})
    end

    it "001 is an instance of Passenger" do
      @passenger.must_be_kind_of RideShare::Passenger
    end

    it "002 throws an argument error with a bad ID value" do
      proc{ RideShare::Passenger.new(id: 0, name: "Smithy")}.must_raise ArgumentError
    end

    #differs from driver_spec-throws error
    it "003 sets trips to an empty array if not provided" do
      @passenger.trips.must_be_kind_of Array
      @passenger.trips.length.must_equal 0
    end

    it "004 is set up for specific attributes and data types" do
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
      trip = RideShare::Trip.new({id: 8, driver: nil, passenger: @passenger, date:Time.parse( "2016-08-08"), rating: 5})

      @passenger.add_trip(trip)
    end

    it "005 each item in array is a Trip instance" do
      @passenger.trips.each do |trip|
        trip.must_be_kind_of RideShare::Trip
      end
    end

    it "006 all Trips must have the same Passenger id" do
      @passenger.trips.each do |trip|
        trip.passenger.id.must_equal 9
      end
    end
  end

  describe "get_drivers method" do
    before do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")
      driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
      trip = RideShare::Trip.new({id: 8, driver: driver, passenger: @passenger, date: "2016-08-08", cost: 23, rating: 5})

      @passenger.add_trip(trip)
    end

    it "007 returns an array" do
      drivers = @passenger.get_drivers
      drivers.must_be_kind_of Array
      drivers.length.must_equal 1
    end

    it "008 all items in array are Driver instances" do
      @passenger.get_drivers.each do |driver|
        driver.must_be_kind_of RideShare::Driver
      end
    end

    describe "total spent by passenger" do

      it "009 returns a total of all money spent by passenger" do
        @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")
        driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
        trip = RideShare::Trip.new({id: 8, driver: driver, passenger: @passenger, date: "2016-08-08", cost: 23, rating: 5})

        @passenger.add_trip(trip)

        trip = @passenger.trips.first

        trip.cost.must_equal 23
      end

      it "010 if passenger has taken no trips, returns nil for total_spent" do
        @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723", trips: [])


        @passenger.total_spent.must_equal 0 

      end
    end


  end
end
