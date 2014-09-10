require './wikidocument'
require 'redis'
require 'json'
require 'uri'
# require 'pry'

a = <<EOF
## WDInstagram with Redis

We're going to create and deploy a photo-sharing Sinatra App that persists using Redis.

#### Config

Because we're deploying tonight's homework to Heroku, you'll have to create your Sinatra app __outside of your `guildenstern` repo.__
EOF

b = <<EOF
#### Part 1: The `Entry`

Create an `Entry` class. Each `Entry` should have the following attributes:

- `author`
- `photo_url`
- `date_taken`
EOF

c = <<EOF
#### Part 2: Routes + Persistence

Your Sinatra app should have the following RESTful route handlers:

- a route that displays all the entries
- a route that dynamically displays a particular entry
- a route that displays a form for creating a new entry
- a route that persists an entry to the data store
- a route that displays a form for editing a particular entry
- a route that takes input from the edit form and updates the entry in the data store
- a route that deletes a specific entry from the datastore
EOF

d = <<EOF
#### Part 3: Heroku + RedisToGo

Deploy your application to Heroku and ensure you're able to persist with RedisToGo.
EOF

e = <<EOF
#### Part 4: Generate Random Entry Using An External API

Add a simple, one-button form to the root URL. This form should POST to "/random_entry".

Add a route, `POST /random_entry`, that persists an entry with randomly assigned values for `author`, `photo_url`, and `date_taken`. You can dynamically grab image urls by hitting the [random_user_api](http://api.randomuser.me/) with HTTParty.
EOF

f = <<EOF
#### Bonus

1. Add validation: `name` and `photo_url` need to be present for an `Entry` to be persisted, and the date_taken should be more can't be in the future. If these attributes aren't present or the user tries to tell you that a photo was taken in the future, redirect the user to the new form page and alert them to their error.

#### Resources

[Redis Ruby Overview](https://github.com/redis/redis-rb/wiki/Redis-rb-Overview)
EOF

g = <<EOF
## Straight CURDing

We're going to continue with the work from today and finish the following user stories.

#### Admin User Stories

![image](http://static.guim.co.uk/sys-images/Guardian/Pix/pictures/2013/3/13/1363190066646/Best-Farmhouse-Cheese-Ins-008.jpg)

1. As an admin, I can seed the database with a json file of cheeses, so that I can develop and test my applicaticon better.
2. As an admin, I can visit a minimalist index page that shows all of the cheese resources.
3. As an admin, I can visit each cheese in the cheese resource, so that I can view specifics about the cheese.
4. As an admin, I can add new cheeses.
5. As an admin, I can remove cheeses.
6. As an admin, I can make changes to a cheese and update it from the cheese's page.
EOF

h = <<EOF
> To edit a cheese, you'll need an **edit** form.  This form will be displayed whenever a GET request is made to /cheeses/:id/edit

> To update a cheese, you'll need to send a `PUT` request from the edit form to `/cheeses/:id`  Don't forget method override!
EOF

i = <<EOF
#### Bonus

![image](http://www.dowdledaily.com/wp-content/uploads/2013/07/wisconsin-cheese-heads.jpg)

# Revisit WDInstagram assignment.

This time ignoring the `Entry` class.  Straight up just stick it in Redis.

Then style the cheese off of it.
EOF

j = <<EOF
## Ruby Weather

You've been tasked with creating a Ruby program for retrieving the current weather conditions in a given city. For example, running `ruby weather.rb 'milwaukee' 'WI'` in the command line should output: `THE CURRENT TEMPERATURE IS: 70.5 DEGREES F`

#### Step 1

Create an account and sign up for an API key at the [weather underground developer center](http://www.wunderground.com/weather/api/d/login.html).
EOF

l = <<EOF
#### Step 2

Explore the Weather Underground API documentation to determine how to structure your query.
EOF

m = <<EOF
#### Step 3

Use `HTTParty` to query the API. Then write your program such that it meets the specification above. (We taught you how to bring in arguments passed in the command line, but you're a human being who forgets things, so Google shamelessly if you've forgotten.)
EOF

n = <<EOF
#### Step 4

Make sure your program works with 2-word states, i.e. "New Hampshire", and two-word cities, .e. "Green Bay"
EOF

o = <<EOF
#### Step 5

Add the hourly forecast to your program. You should have the additional output of something like this:

```
At 8:00 AM it'll be 72 degrees fahrenheit
At 9:00 AM it'll be 73 degrees fahrenheit
At 10:00 AM it'll be 75 degrees fahrenheit
At 11:00 AM it'll be 77 degrees fahrenheit
At 12:00 PM it'll be 79 degrees fahrenheit
At 1:00 PM it'll be 80 degrees fahrenheit
At 2:00 PM it'll be 83 degrees fahrenheit
At 3:00 PM it'll be 85 degrees fahrenheit
At 4:00 PM it'll be 87 degrees fahrenheit
At 5:00 PM it'll be 87 degrees fahrenheit
At 6:00 PM it'll be 87 degrees fahrenheit
At 7:00 PM it'll be 86 degrees fahrenheit
At 8:00 PM it'll be 84 degrees fahrenheit
At 9:00 PM it'll be 82 degrees fahrenheit
At 10:00 PM it'll be 81 degrees fahrenheit
At 11:00 PM it'll be 81 degrees fahrenheit
At 12:00 AM it'll be 80 degrees fahrenheit
At 1:00 AM it'll be 79 degrees fahrenheit
At 2:00 AM it'll be 79 degrees fahrenheit
At 3:00 AM it'll be 79 degrees fahrenheit
At 4:00 AM it'll be 79 degrees fahrenheit
At 5:00 AM it'll be 77 degrees fahrenheit
At 6:00 AM it'll be 77 degrees fahrenheit
At 7:00 AM it'll be 75 degrees fahrenheit
```
EOF

p = <<EOF
#### Bonus

* Make this program an executable, so you can type `weather 'green bay' 'wi'` from any directory and still get the desired output.
* Alter your output for the hourly to only show the forecast for every 3 hours.
* Add the text description of the condition expected for that time too.
EOF


authors = ["Phil", "PJ", "Travis"]
texts = [a, b, c, d, e, f, g, h, i, j, l,
  m, n, o, p ]


uri = URI.parse(ENV["REDISTOGO_URL"])
$redis = Redis.new({:host => uri.host,
                :port => uri.port,
                :password => uri.password})



counter = 25
while counter > 0
  doc = WikiDocument.new(
      "\#placeholderstory#{counter}",
      authors.sample,
      texts.sample)
  $redis.set(doc.key, doc.to_json)
  counter -= 1
  # binding.pry
end
