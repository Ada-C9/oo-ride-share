require_relative 'spec_helper'
require 'pry'

describe "Driver class" do

  describe "Driver instantiation" do
    before do
      @driver = RideShare::Driver.new(id: 1, name: "George", vin: "33133313331333133")
    end

    it "is an instance of Driver" do
      @driver.must_be_kind_of RideShare::Driver
    end

    it "throws an argument error with a bad ID value" do
      proc{ RideShare::Driver.new(id: 0, name: "George", vin: "33133313331333133")}.must_raise ArgumentError
    end

    it "throws an argument error with a bad VIN value" do
      proc{ RideShare::Driver.new(id: 100, name: "George", vin: "")}.must_raise ArgumentError
      proc{ RideShare::Driver.new(id: 100, name: "George", vin: "33133313331333133extranums")}.must_raise ArgumentError
    end

    it "sets trips to an empty array if not provided" do
      @driver.trips.must_be_kind_of Array
      @driver.trips.length.must_equal 0
    end

    it "is set up for specific attributes and data types" do
      [:id, :name, :vehicle_id, :status].each do |prop|
        @driver.must_respond_to prop
      end

      @driver.id.must_be_kind_of Integer
      @driver.name.must_be_kind_of String
      @driver.vehicle_id.must_be_kind_of String
      @driver.status.must_be_kind_of Symbol
    end
  end

  describe "add trip method" do
    before do
      pass = RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640")
      @driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
      @trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: pass, start_time: Time.parse("2016-04-05T14:09:00+00:00"),
        end_time: Time.parse("2016-04-05T14:25:00+00:00"), rating: 5})
      end

      it "throws an argument error if trip is not provided" do
        proc{ @driver.add_trip(1) }.must_raise ArgumentError
      end

      it "increases the trip count by one" do
        previous = @driver.trips.length
        @driver.add_trip(@trip)
        @driver.trips.length.must_equal previous + 1
      end
  end

    describe "average_rating method" do
      before do
        @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
        trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: nil, start_time: Time.parse("2016-04-05T14:09:00+00:00"),
          end_time: Time.parse("2016-04-05T14:25:00+00:00"), rating: 5})
          @driver.add_trip(trip)
      end

      it "returns a float" do
        @driver.average_rating.must_be_kind_of Float
      end

      it "returns a float within range of 1.0 to 5.0" do
        average = @driver.average_rating
        average.must_be :>=, 1.0
        average.must_be :<=, 5.0
      end

      it "returns zero if no trips" do
        driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
        driver.average_rating.must_equal 0
      end
    end

    describe 'total_revenue method' do
      before do
        pass = RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640")
        @driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
        trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: pass, start_time: Time.parse("2016-04-05T14:09:00+00:00"),
          end_time: Time.parse("2016-04-05T14:25:00+00:00"), cost: 12.0, rating: 5})

          @driver.add_trip(trip)
        end
      it "returns a float" do
        @driver.total_revenue.must_be_instance_of Float
      end

      it "returns total revenue made" do
        @driver.total_revenue.must_equal 8.28
        # add another trip below should change the new total revenue:

        pass1 = RideShare::Passenger.new(id: 3, name: "Ada", phone: "412-432-7640")
        trip2 = RideShare::Trip.new({id: 10, driver: @driver, passenger: pass1, start_time: Time.parse("2016-04-05T14:09:00+00:00"),
          end_time: Time.parse("2016-04-05T14:25:00+00:00"), cost: 15.0, rating: 5})


          @driver.add_trip(trip2)
          @driver.total_revenue.must_equal 18.96
      end

      it "does not count trips with nil end_time" do

        @driver.total_revenue.must_equal 8.28

        pass1 = RideShare::Passenger.new(id: 3, name: "Ada", phone: "412-432-7640")

        trip2 = RideShare::Trip.new({id: 10, driver: @driver, passenger: pass1, start_time: Time.parse("2016-04-05T14:09:00+00:00"),
          end_time: nil, cost: nil, rating: nil})

        @driver.total_revenue.must_equal 8.28
      end

    end


    describe 'average_revenue method' do
      before do
    pass1 = RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640")
    @driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")

    pass2 = RideShare::Passenger.new(id: 5, name: "", phone: "412-432-7640")
    @driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")

    trip1 = RideShare::Trip.new({id: 8, driver: @driver, passenger: pass1, start_time: Time.parse("2016-04-05T14:09:00+00:00"),
      end_time: Time.parse("2016-04-05T14:25:00+00:00"),
      cost: 12.0, rating: 5})

    trip2 = RideShare::Trip.new({id: 6, driver: @driver, passenger: pass2, start_time: Time.parse("2016-04-05T14:09:00+00:00"),
    end_time: Time.parse("2016-04-05T14:25:00+00:00"),
    cost: 15.0,rating: 4})

    @driver.add_trip(trip1)
    @driver.add_trip(trip2)
    end

      it "returns a float" do
        @driver.average_revenue.must_be_instance_of Float
      end

      it "returns average revenue made" do
        @driver.average_revenue.must_equal 9.48
      end
    end
end # end of "describe "Driver instantiation" do"
