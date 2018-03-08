require 'simplecov'
SimpleCov.start

require_relative 'spec_helper'



describe "Reservation class" do

  describe "initialize" do
    before do
      @room_data = {
        number: 8,
        cost: 800.00
        date: 2010-10-31

        }




        #it throws an argument error when an invalid date is put down

      @room = Room.new(@room_data)

    end

    # it "is an instance of Room" do
    #   @room.must_be_kind_of Room
    # end

    it "stores an instance of date" do
      @room.number.must_be_kind_of Fixnum
    end

    it "stores an instance of cost" do
      @room.cost.must_be_kind_of Float
    end


    it "returns an array of all dates" do
      result = Reservations.all
      result.wont_be_empty
    end


    it "raises an error if date is already booked" do

test_reservation = Reservation.new[]

    # describe "request reservation" do
    #   before do
    #
    #     start_date = Date.parse ("2010-10-31")
    #
    #     end_date =
    #
    #
    #

        # reservation_data = {
        #   id: 8,
        #   driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
        #   passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        #   start_time: start_time,
        #   end_time: end_time,
        #   cost: 800.00,
        #   rating: 3
        # }




      end
    end





     end

  end
