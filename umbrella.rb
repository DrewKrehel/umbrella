require "http"
require "json"
require "dotenv/load"

puts "where are you located?"
user_location = gets.chomp 
# user_location = "Chicago"
# user_location = "Philidelphia"
pp user_location

maps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + user_location + "&key=" + ENV.fetch("GMAPS_KEY")

resp = HTTP.get(maps_url)
raw_response2 = resp.to_s
parsed_response = JSON.parse(raw_response2)
results = parsed_response.fetch("results")
first_result = results.at(0)
geo = first_result.fetch("geometry")
loc = geo.fetch("location")
pp latitude = loc.fetch("lat")
pp longitutde = loc.fetch("lng")

# Hidden variables
pirate_weather_key = ENV.fetch("PIRATE_WEATHER_KEY")

# Assemble the full URL string by adding the first part, the API token, and the last part together
pirate_weather_url = "https://api.pirateweather.net/forecast/" + pirate_weather_key + "/#{latitude},#{longitutde}"

# Place a GET request to the URL
raw_response = HTTP.get(pirate_weather_url)
parsed_response = JSON.parse(raw_response)

currently_hash = parsed_response.fetch("currently")
current_temp = currently_hash.fetch("temperature")
puts "The current temperature is " + current_temp.to_s + "."

next_hour = currently_hash.fetch("summary")
puts "Next hour: " + next_hour

forcast = currently_hash.fetch("precipType")
case forcast
when "rain"
  puts "Bring an umbrella."
when "snow"
  puts "Bring snow boots."
when "sleet"
  puts "Don't slip."
else
  puts "You probably won't need an umbrella."
end
