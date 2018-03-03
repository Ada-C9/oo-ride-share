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
      end_time = start_time + 25 * 60 # 25 minutes

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

      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes

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
  end

  describe "add_trip(trip)" do
    it "adds trip to passengers collection of trips" do
      passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")

      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60

      orginal_trips_count = passenger.trips.length

      trip = RideShare::Trip.new({id: 8, driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"), passenger: passenger, start_time: start_time, end_time: end_time, rating: 5})

      passenger.add_trip(trip)

      passenger.trips.length.must_equal orginal_trips_count + 1

    end
  end

  describe "calculate_total_money_spent" do

    before do
      @passenger = RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640")

      @driver = RideShare::Driver.new(id: 4, name: "Bob", vin: "12345678412335678")

      @start_time = Time.parse('2015-05-20T12:14:00+00:00')
      @end_time = @start_time + 25 * 60 # 25 minutes

      @first_trip_data = {
        id: 8,
        driver: @driver,
        passenger: @passenger,
        start_time: @start_time,
        end_time: @end_time,
        cost: 23.45,
        rating: 3
      }
      @second_trip_data = {
        id: 9,
        driver: @driver,
        passenger: @passenger,
        start_time: @start_time,
        end_time: @end_time,
        cost: 55.66,
        rating: 5
      }

      @passenger.add_trip(RideShare::Trip.new(@first_trip_data))
      @passenger.add_trip(RideShare::Trip.new(@second_trip_data))

    end

    it "Returns sum of all trip costs" do

      @passenger.calculate_total_money_spent.must_equal 79.11

    end

    it "Excludes in progress trips from calculation" do
      in_progress_trip_data = {
        id: 10,
        driver: @driver,
        passenger: @passenger,
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil,
      }

      in_progress_trip = RideShare::Trip.new(in_progress_trip_data)

      @passenger.add_trip(in_progress_trip)

      @passenger.calculate_total_money_spent.must_equal 79.11
      @passenger.trips.length.must_equal 3
    end

  end

  describe "Total duration of trips method" do

    before do
      @passenger = RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640")

      @driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")

      @start_time = Time.parse('2015-05-20T12:14:00+00:00')
      @end_time = @start_time + 25 * 60 # 25 minutes

      @first_trip_data = {
        id: 8,
        driver: @driver,
        passenger: @passenger,
        start_time: @start_time,
        end_time: @end_time,
        cost: 23.45,
        rating: 3
      }
      @second_trip_data = {
        id: 9,
        driver: @driver,
        passenger: @passenger,
        start_time: @start_time,
        end_time: @end_time,
        cost: 55.66,
        rating: 5
      }

      @passenger.add_trip(RideShare::Trip.new(@first_trip_data))
      @passenger.add_trip(RideShare::Trip.new(@second_trip_data))

    end

    it "Calculates total time passenger has spent on their trips" do

      @passenger.calculate_total_trips_duration.must_equal 3000 #3000 seconds

    end

    it "Excludes in progress trips from calculation" do
      in_progress_trip_data = {
        id: 10,
        driver: @driver,
        passenger: @passenger,
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil,
      }

    in_progress_trip = RideShare::Trip.new(in_progress_trip_data)

    @passenger.add_trip(in_progress_trip)

    @passenger.calculate_total_trips_duration.must_equal 3000
    @passenger.trips.length.must_equal 3

    end

  end

end
