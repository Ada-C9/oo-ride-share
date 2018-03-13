TOPIC 1.  WORKING WITH TIME IN RUBY:  

In this project, we have to process time in Ruby.  Specifically, we have the
following instructions:

    (1) Spend some time reading the docs for Time - you might be particularly interested in Time.parse.

    (2)  Modify TripDispatcher#load_trips to store the start_time and end_time as Time instances.

    (3)  Add a check in Trip#initialize that raises an ArgumentError if the end time is before the start time, and a  corresponding test.

    (4) Add an instance method to the Trip class to calculate the duration of the trip in seconds, and a corresponding test.

As an example of what we're dealing with, here's a line from the relevant CSV:

      1,1,54,2016-04-05T14:01:00+00:00,2016-04-05T14:09:00+00:00,17.39,3

Of that, the important bits are:

        2016-04-05T14:01:00+00:00,2016-04-05T14:09:00+00:00

Which are contained in columns 4 and 5.


The current code from the Trip Dispatch method is:

def load_trips
  trips = []
  trip_data = CSV.open('support/trips.csv', 'r', headers: true, header_converters: :symbol)

  trip_data.each do |raw_trip|
    driver = find_driver(raw_trip[:driver_id].to_i)
    passenger = find_passenger(raw_trip[:passenger_id].to_i)

    parsed_trip = {
      id: raw_trip[:id].to_i,
      driver: driver,
      passenger: passenger,
      start_time: raw_trip[:start_time],
      end_time: raw_trip[:end_time],
      cost: raw_trip[:cost].to_f,
      rating: raw_trip[:rating].to_i
    }

    trip = Trip.new(parsed_trip)
    driver.add_trip(trip)
    passenger.add_trip(trip)
    trips << trip
  end

  trips
end

So, walking through that:

  1.  trips is declared as an open array.

  2.  The trip data CSV is opened as read-only, with headers, which are converted to symbols.

  3.  The method iterates through the CSV line-by-line, and:

        a.  Converts the driver ID to an integer
        b.  Converst the passenger ID to an integer
        c.  Assigns the line of trip data to a hash called parsed_trip, which contains
            keys for:  
                id, driver, passenger, start_time, end_time, cost, and rating

        d.  Uses the parsed trip hash to create a new instance of Trip and store
            it to a variable called "trip" (FML)
        e.  Uses driver's add_trip method to add the contents of "trip" to driver's
            @trips array.
        f.  Uses passenger's add_trip method to add thje contents of "trip" to
            passenger's "trip" array.
        g.  Shovels the contents of "trip" into its own @trips array.

  4.  Returns the value of its own @trips array.

So, understanding that, it seems like what we would want to do would logically
fit in at about line 35 of this ReadMe, right under the special (to_i) handling
of the driver and passenger ID fields, in the line-by-line CSV handling loop.
Awesome!  Let's figure out how to do that!

We'll start at the Ruby docs.

Per the Ruby docs, to create an instance of Ruby's Time class, the basic syntax
is:  

      Time.new(2002)

  Which, in that case, would yield:  

      2002-01-01 00:00:00 -0500

When I tried that with the contents of one of the start time fields from our
CSV, I got the following error:  

          SyntaxError: unexpected tCONSTANT, expecting ')'
          TIme.new(2016-04-05T14:01:00+00:00)
                         ^~~

Which, plainly, is happening because of the T in the middle of our string.  
That T appears to divide the hour from the date.  

Fortunately for us, we know that we can split something at a character of
our choosing via a number of methods.  

When I did a trial in IRB to see if changing the T to a comma would solve our
problems, I still got an error, because, apparently, Time.new() does not like
colons either.  What it wants are commas-- just commas for days. Here's an
example from the Ruby docs:

      Time.new(2002, 10, 31, 2, 2, 2, "+02:00") #=> 2002-10-31 02:02:02 +0200

So that means that we need to read this in a way that gets rid of all the hyphens
and such, and just return something with the values separated by ", ", and with
the timezone bit at the end that begins with "+", (i.e., "+00:00"), set off in
double-quotes.

  (I should note here that, when I put our CSV string into that format, it
    worked a charm in IRB.  So we can be certain of our path forward.)

Awesome again!  Let's figure out how to do that!

I think the first thing we need to do is split out the timezone bit using a
regexp.  There's just no help for it.  If it's still there when the rest of
the string gets processed, it'll get broken up in exactly the wrong way, so it
has to be handled first.

Actually, scratch that.  Before we go ot Regexp Hell, let's -juuuust- have a look
at Time.parse and see if we get something better.


So, to recap:  


The relevant handling loop we need to fit into is:

trip_data.each do |raw_trip|
  driver = find_driver(raw_trip[:driver_id].to_i)
  passenger = find_passenger(raw_trip[:passenger_id].to_i)

And what we want to process is:

  2016-04-05T14:01:00+00:00

So, let's PSEUDOCODE that:

1. Find the header, which is start_time, so, roughly:
      start_time = find_start_time(raw_trip[:start_time].A_METHOD_HAPPENS)
      ** NOTE HERE THAT THERE NEEDS TO BE A find_start_time helper method,
        like the existing find_driver and find_passenger methods.

2. The method that has to happen is:

    Time.new(correctly_processed_time_string)

3.  So, how's that processing going to work?
    -- As a helper method, clearly.  

4.  What does that helper method look like?
    a. remove all "-" and replace with ", ".
    b. remove "T" and replace with ", "
    c. identify anchoring "+00:00" (or any series of numbers begining with +,
        followed by two digits, a colon, and another two digits, enclose in "",
        and set aside, to be added to the end of the (string? expression? what??
          thinking I'm going to go with "thingee," here) thingee.


****ACTUALLY, LET'S PUT A PIN IN THIS.******

Because we can use Time.parse() to convert the strings we have into Time objects.

Given the template we have:  

trip_data.each do |raw_trip|
  driver = find_driver(raw_trip[:driver_id].to_i)
  passenger = find_passenger(raw_trip[:passenger_id].to_i)

I think we can do:

start_time = find_start_time(Time.parse(raw_trip[:start_time]))

and

end_time = find_end_time(Time.parse(raw_trip[:end_time]))

or something like that. 
