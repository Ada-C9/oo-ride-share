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
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = Time.parse('2015-05-20T12:16:00+00:00')
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723", trips: [])
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
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = Time.parse('2015-05-20T12:16:00+00:00')

      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")
      driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
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

    describe "#total_money_spent" do
      before do
        start_time = Time.parse('2015-05-20T12:14:00+00:00')
        end_time = Time.parse('2015-05-20T12:16:00+00:00')
        @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723", trips: [])
        trip = RideShare::Trip.new({id: 8, driver: nil, passenger: @passenger, start_time: start_time, end_time: end_time, cost: 27.456, rating: 5})

        trip1 = RideShare::Trip.new({id: 8, driver: nil, passenger: @passenger, start_time: start_time, end_time: end_time, cost: 45.34, rating: 5})


        @passenger.add_trip(trip)
        @passenger.add_trip(trip1)
      end

      it "return the total amount of money that passenger has spent on their trips" do
        @passenger.total_money_spent.must_equal 72.8
        @passenger.total_money_spent.must_be_instance_of Float
      end
    end

    describe "#total_time_spent" do
      before do
        start_time = Time.parse('2015-05-20T12:14:00+00:00')
        end_time = Time.parse('2015-05-20T14:16:23+00:00')
        @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723", trips: [])
        trip = RideShare::Trip.new({id: 8, driver: nil, passenger: @passenger, start_time: start_time, end_time: end_time, cost: 27, rating: 5})

        trip1 = RideShare::Trip.new({id: 8, driver: nil, passenger: @passenger, start_time: start_time, end_time: end_time, cost: 45, rating: 5})


        @passenger.add_trip(trip)
        @passenger.add_trip(trip1)
      end

      it "return the total amount of time that passenger has spent on their trips" do
        @passenger.total_time_spent.must_equal 14686
        @passenger.total_time_spent.must_be_instance_of Integer

      end
    end

    describe "#add_trip" do
      before do
        @passenger = RideShare::Passenger.new({id: 1, name: "Smithy", phone: "353-533-5334",trips: []})
        @trip_data = {
          id: 8,
          driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
          passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
          start_time: Time.parse('2015-05-20T12:14:00+00:00'),
          end_time: Time.parse('2015-05-20T12:16:00+00:00'),
          cost: 23.45,
          rating: 3
        }

      end
      it "Add the new trip to the collection of trips for the Passenger" do
        before_count = @passenger.trips.count
        @passenger.add_trip(@trip)
        expected_count = before_count + 1
        @passenger.trips.count.must_equal expected_count
      end
    end


  end
end
