require_relative 'spec_helper'

describe "Passenger class" do

  describe "Passenger instantiation" do
    before do
      @passenger = RideShare::Passenger.new({id: 1, name: "Smithy",
        phone: "353-533-5334"})
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


  describe "get_total_money_spent" do

    before do
      driver1 = RideShare::Driver.new(id: 3, name: "Lovelace",
        vin: "12345678912345678")

      driver2 = RideShare::Driver.new(id: 4, name: "Lovelace",
        vin: "12345678912345678")

      driver3 = RideShare::Driver.new(id: 8, name: "Lovelace",
        vin: "12345678912345678")

      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III",
         phone: "1-602-620-2330 x3723", trips: [])

      @trip1 = RideShare::Trip.new({id: 3, driver: driver1, passenger: @passenger,
        start_time: Time.parse("2018-01-02T10:40:00+00:00"),
        end_time: Time.parse("2018-01-02T11:00:00+00:00"), cost: 20.45,
        rating: 5})

      @trip2 = RideShare::Trip.new({id: 5, driver: driver2, passenger: @passenger,
        start_time: Time.parse("2018-01-04T10:45:00+00:00"),
        end_time: Time.parse("2018-01-4T11:15:00+00:00"), cost: 10.05,
        rating: 4})

      @trip3 = RideShare::Trip.new({id: 22, driver: driver3, passenger: @passenger,
        start_time: Time.parse("2018-01-05T09:30:00+00:00"),
        end_time: Time.parse("2018-01-05T10:00:00+00:00"), cost: 11.0,
        rating: 2})
      [@trip1, @trip2, @trip3].each { |trip| @passenger.add_trip(trip)}
    end

    it "calculates total money spent" do
      expected_total = 20.45 + 10.05 + 11.0
      @passenger.get_total_money_spent.must_be_kind_of Float
      @passenger.get_total_money_spent.must_equal expected_total

    end

    it "returns 0.0 if no trips taken" do
      new_passenger = RideShare::Passenger.new(id: 9, name: "No Trips Passenger",
         phone: "1-902-620-2330 x3723", trips: [])
      new_passenger.get_total_money_spent.must_equal 0.0
    end

    # TODO: doesn't return negative money??
  end

  describe "calculates the total trips time" do

    before do
      driver1 = RideShare::Driver.new(id: 3, name: "Lovelace",
        vin: "12345678912345678")

      driver2 = RideShare::Driver.new(id: 4, name: "Lovelace",
        vin: "12345678912345678")

      driver3 = RideShare::Driver.new(id: 8, name: "Lovelace",
        vin: "12345678912345678")

      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III",
         phone: "1-602-620-2330 x3723", trips: [])

      @trip1 = RideShare::Trip.new({id: 3, driver: driver1, passenger: @passenger,
        start_time: Time.parse("2018-01-02T10:40:00+00:00"),
        end_time: Time.parse("2018-01-02T11:00:00+00:00"), cost: 20.45,
        rating: 5})

      @trip2 = RideShare::Trip.new({id: 5, driver: driver2, passenger: @passenger,
        start_time: Time.parse("2018-01-04T10:45:00+00:00"),
        end_time: Time.parse("2018-01-4T11:15:00+00:00"), cost: 10.05,
        rating: 5})

      @trip3 = RideShare::Trip.new({id: 22, driver: driver3, passenger: @passenger,
        start_time: Time.parse("2018-01-05T09:30:00+00:00"),
        end_time: Time.parse("2018-01-05T10:00:00+00:00"), cost: 11.0,
        rating: 5})

      [@trip1, @trip2, @trip3].each { |trip| @passenger.add_trip(trip)}

      @total_time_spent = [@trip1, @trip2, @trip3].inject(0) {
        |sum, trip| sum + trip.get_duration }
    end

    it "calculates total time spent" do
      # expected_total = 20.45 + 10.05 + 11.0
      @passenger.get_total_time.must_be_kind_of Integer
      @passenger.get_total_time.must_equal @total_time_spent
    end

    it "return 0 if no trips" do
      new_passenger = RideShare::Passenger.new(id: 9, name: "No Trips Passenger",
         phone: "1-902-620-2330 x3723", trips: [])
      new_passenger.get_total_time.must_equal 0
    end

    # it "returns 0.0 if no trips taken" do
    #   new_passenger = RideShare::Passenger.new(id: 9, name: "No Trips Passenger",
    #      phone: "1-902-620-2330 x3723", trips: [])
    #   new_passenger.get_total_money_spent.must_equal 0.0
    # end

  end


  describe "trips property" do
    before do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III",
         phone: "1-602-620-2330 x3723", trips: [])
      driver = RideShare::Driver.new(id: 3, name: "Lovelace",
           vin: "12345678912345678")
      trip = RideShare::Trip.new({id: 8, driver: driver, passenger: @passenger,
        start_time: Time.parse("2018-01-02T10:42:00+00:00"),
        end_time: Time.parse("2018-01-02T11:27:00+00:00"), cost: 3.23, rating: 5})

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
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III",
         phone: "1-602-620-2330 x3723")
      driver = RideShare::Driver.new(id: 3, name: "Lovelace",
        vin: "12345678912345678")
      trip = RideShare::Trip.new({id: 8, driver: driver, passenger: @passenger,
        start_time: Time.parse("2018-01-02T10:42:00+00:00"),
        end_time: Time.parse("2018-01-02T11:27:00+00:00"), rating: 5})

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
