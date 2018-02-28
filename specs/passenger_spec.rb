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
      trip = RideShare::Trip.new({id: 8, driver: nil, passenger: @passenger, start_time: "2016-08-08", rating: 5})

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
      trip = RideShare::Trip.new({id: 8, driver: driver, passenger: @passenger, start_time: "2016-08-08", rating: 5})

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

  describe "total_spending method" do
    it "returns passenger's total spending of all trips" do
      passenger_data = {
        id: 3,
        name: "Lovelace",
        phone: "206-432-7640"
      }
      passenger = RideShare::Passenger.new(passenger_data)

      start_time_1 = Time.parse('2015-05-20T12:14:00+00:00')
      end_time_1 = start_time_1 + 40 * 60
      trip_1 = {
        id: 8,
        driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
        passenger: passenger,
        start_time: start_time_1,
        end_time: end_time_1,
        cost: 50.45,
        rating: 4
      }

      start_time_2 = Time.parse('2015-07-20T12:14:00+00:00')
      end_time_2 = start_time_2 + 20 * 60
      trip_2 = {
        id: 9,
        driver: RideShare::Driver.new(id: 4, name: "Ada", vin: "12345678910045678"),
        passenger: passenger,
        phone: "412-432-7640",
        start_time: start_time_2,
        end_time: end_time_2,
        cost: 23.45,
        rating: 3
      }

      start_time_3 = Time.parse('2015-09-20T12:14:00+00:00')
      end_time_3 = start_time_3 + 90 * 60
      trip_3 = {
        id: 10,
        driver: RideShare::Driver.new(id: 6, name: "Coco", vin: "10045678912345678"),
        passenger: passenger,
        phone: "412-432-7640",
        start_time: start_time_3,
        end_time: end_time_3,
        cost: 99.45,
        rating: 5
      }

      trips = [
        RideShare::Trip.new(trip_1),
        RideShare::Trip.new(trip_2),
        RideShare::Trip.new(trip_3)
      ]

      trips.each do |trip|
        passenger.add_trip(trip)
      end

      passenger.total_spending.must_equal 173.35
    end
  end


  describe "total_time method" do
    it "returns total time that passenger has spent on all trips" do
    end
    
  end
end
