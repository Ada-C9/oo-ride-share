require_relative 'spec_helper'
require_relative '../lib/trip'

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
      trip = RideShare::Trip.new({id: 8, driver: nil, passenger: @passenger, start_time: Time.new("2016-08-08"), end_time: Time.new("2016-08-09"), rating: 5})

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

  describe "total_amount_of_money method" do
    it "returns total amount of money" do

      start_time = Time.parse("2018-03-01 07:45:16 -080")
      end_time = Time.parse("2018-03-01 09:45:16 -080")

      test_trip = RideShare::Trip.new({ :cost => 1.50, :rating => 3, :start_time => start_time, :end_time => end_time})

      test_passenger = RideShare::Passenger.new( { :id => 1, :trips => [ test_trip ]  } )

      test_total = test_passenger.get_total_money
      # this should be total amount of money
      test_total.must_equal 1.50
    end
  end

  describe "total_amount_of_money" do
      it "returns zero amount of money" do

      #  start_time = Time.parse("2018-03-01 07:45:16 -080")
      #  end_time = Time.parse("2018-03-01 07:45:16 -080")
       #
      #  test_trip = RideShare::Trip.new({ :cost => 1.50, :rating => 3, :start_time => start_time, :end_time => end_time})
       #
       test_passenger = RideShare::Passenger.new({ :id => 1, :trips => [ ]  } )

       test_total = test_passenger.get_total_money
           # this should be total amount of money
       test_total.must_equal 0
         end
       end

  #it must return an accurate amount of money





    describe "total amount of time" do
      it "returns total ride time" do
        start_time = Time.parse("2018-03-01 07:45:16 -080")
        end_time = Time.parse("2018-03-01 09:45:16 -080")
        test_trip = RideShare::Trip.new({:start_time => start_time, :rating => 4, :end_time => end_time})
        test_passenger = RideShare::Passenger.new({ :id =>5, :trips => [test_trip]})
        test_time = test_passenger.total_time

        test_time.must_equal 7.2 * 1000
      end
    end

    describe "total amount of time" do
      it "returns no time" do
      test_passenger = RideShare::Passenger.new({ :id =>5, :trips => []})
      end
    end




    describe "get_drivers method" do
      before do
        @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")
        driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
        trip = RideShare::Trip.new({id: 8, driver: driver, passenger: @passenger, start_time: Time.new("2016-08-08"), end_time: Time.new("2016-08-09"), rating: 5})

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
