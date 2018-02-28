# # Input: instance of Driver
# # Output: Total Revenue (float)
# # Where does it live? Driver#total_revenue
# # this would be
# # Pseudocode: total Revenue for Driver
#
fee = 1.65
subtotal = 0
driver_takehome = 0.8

@trips.each do |trip|
  # Question: what if the cost is less than the fee
  if trip.cost < fee
    subtotal += trip.cost
  end
  if trip.cost >= fee
    subtotal += (trip.cost - fee)
  end
  must_respond_to

  total = subtotal * driver_takehome
  return total
end

# # Test 1: two trips
#
# trips = [
#   RideShare::Trip.new({cost: 5, rating: 3}),
#   RideShare::Trip.new({cost: 7, rating: 3}),
#   RideShare::Trip.new({cost: 8, rating: 3})
# ]
#
# driver_data = {
#   id: 7,
#   vin: 'a' * 17,
#   name: 'test driver',
#   trips: trips
# }
#
# driver = Driver.new(driver_data)
#
# driver.total_revenue.must_equal 8

# return the time when the movie is over
# ADD:
# * showtime from the ticket
# * runtime from the Movie


# class Movie
#   attr_reader :runtime, :title
#
#   def initialize(runtime, title)
#     @runtime = runtime
#     @title = title
#   end
#
#   def new_ticket(showtime, seat)
#     Ticket.new(showtime, seat, self)
#   end
# end
#
# MOVIES = [ Movie.new(120, "Three Billboards"), Movie.new(180, "Black Panther")]
#
# class Ticket
#   attr_reader :showtime, :seat, :movie
#
#   def initialize(showtime, seat, movie)
#     @showtime = showtime
#     @seat = seat
#     @movie = movie
#   end
#
#   def end_time
#
#     showtime + movie.runtime
#   end
#
#   def title
#     movie.title
#   end
#
#
# end
#
# bp = MOVIES[1]
# ticket = bp.new_ticket(2000, 34)
#
# puts ticket.end_time


def coffee_price(*type, size, extra_shots: 0)
  # Find the base price for this drink
  case type
  when :drip
    price = 1.5
  when :latte
    price = 3.7
  when :cappuccino
    price = 3.2
  else
    puts "Invalid coffee type: #{type}"
    return
  end

  # Modify for size
  case size
  when :tall
    # No change
  when :grande
    price *= 1.3
  when :venti
    price *= 1.6
  else
    puts "Invalid size: #{size}"
    return
  end

  # Charge for extra shots
  price += extra_shots * 0.5

  # Charge for a cold drink
  if cold
    price += 1
  end

  return price
end


puts coffee_price(:drip, :tall)
puts coffee_price(:drip, :tall, 1)
puts coffee_price(:drip, :tall, 2)
puts coffee_price(:drip, :tall, 2, true)
