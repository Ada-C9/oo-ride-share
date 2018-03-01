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
      trip = RideShare::Trip.new({id: 8, driver: nil, passenger: @passenger, start_time: Time.parse('2016-01-13T13:16:00+00:00'), end_time: Time.parse('2016-01-13T13:28:00+00:00'), rating: 5})

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
      trip = RideShare::Trip.new({id: 8, driver: driver, passenger: @passenger,start_time: Time.parse('2016-01-13T13:16:00+00:00'), end_time: Time.parse('2016-01-13T13:28:00+00:00'), rating: 5})

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

  describe "passenger_spents method" do
    before do
      @trips = [RideShare::Trip.new({rating: 3, cost: 10}), RideShare::Trip.new({rating: 5, cost: 10})]
    end

    it 'returns amount spent by the passenger' do
      @passenger = RideShare::Passenger.new({id: 1, name: "Smithy", phone: "353-533-5334",trips: @trips})
      result = @passenger.passenger_spents
      expected_spent = 20
      result.must_equal expected_spent
    end

    it 'returns 0 if the passenger has no trips' do
      @passenger = RideShare::Passenger.new({id: 1, name: "Smithy", phone: "353-533-5334",
        trips: []})
      result = @passenger.passenger_spents
      expected_spent = 0
      result.must_equal expected_spent
    end
  end

  describe "travel time method" do
    before do
      @start_time_1 = Time.parse('2016-08-08T16:01:00+00:00')
      @end_time_1 = @start_time_1 + 30*60
      @start_time_2 = Time.parse('2016-08-08T16:01:00+00:00')
      @end_time_2 = @start_time_2 + 20*60

      @trips = [RideShare::Trip.new({rating: 3, start_time: @start_time_1, end_time: @end_time_1 }),
        RideShare::Trip.new({rating: 5, start_time: @start_time_2, end_time: @end_time_2 })]
    end

    it "returns amount of time (minutes) the passenger spent on their trip " do
      @passenger = RideShare::Passenger.new({id: 1, name: "Smithy", phone: "353-533-5334", trips: @trips})
      result_minutes = @passenger.travel_time
      expected_time = 50*60
      result_minutes.must_equal expected_time
    end

    it "returns 0 as amount of time if the passenger has no trips " do
      @passenger = RideShare::Passenger.new({id: 1, name: "Smithy", phone: "353-533-5334", trips:[]})
      result = @passenger.travel_time
      expected_time = 0
      result.must_equal expected_time
    end
  end
end
