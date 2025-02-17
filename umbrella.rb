require "http"
require "json"
require "dotenv/load"
require "ascii_charts"

line_length = 40
puts "=" * line_length
puts "Will you need an umbrella today?".center(line_width)
puts "=" * line_length
puts
puts "Where are you located?"
# user_location = gets.chomp 
# user_location = "Chicago"
# user_location = "Philidelphia"
user_location = "Seattle"
puts user_location
puts "Checking the weather at #{user_location}...."

maps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + user_location + "&key=" + ENV.fetch("GMAPS_KEY")

resp = HTTP.get(maps_url)
raw_response2 = resp.to_s
parsed_response = JSON.parse(raw_response2)
results = parsed_response.fetch("results")
first_result = results.at(0)
geo = first_result.fetch("geometry")
loc = geo.fetch("location")
latitude = loc.fetch("lat")
longitude = loc.fetch("lng")

puts "Your coordinate are #{latitude}, #{longitude}"

# Hidden variables
pirate_weather_key = ENV.fetch("PIRATE_WEATHER_KEY")

# Assemble the full URL string by adding the first part, the API token, and the last part together
pirate_weather_url = "https://api.pirateweather.net/forecast/" + pirate_weather_key + "/#{latitude},#{longitude}"

# Place a GET request to the URL
raw_response = HTTP.get(pirate_weather_url)
parsed_response = JSON.parse(raw_response)

currently_hash = parsed_response.fetch("currently")
current_temp = currently_hash.fetch("temperature")
puts "The current temperature is " + current_temp.to_s + "."

next_hour = currently_hash.fetch("summary")
puts "Next hour: " + next_hour

hourly_hash = parsed_response.fetch("hourly")
hour_data = hourly_hash.fetch("data")
next_12_hours = hour_data[0..11]
# hour_precip = hour_data[0].fetch("precipProbability")
puts "In 0 hours, there is a #{hour_data[0].fetch("precipProbability")*100}% chance of precipitation."

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

puts "\nHours from now vs Precipitation probability"

precip_array = next_12_hours.map {|hour| hour.fetch("precipProbability")}
chart_array = precip_array.each_with_index.map {|data, index| [index+1, data]}
puts AsciiCharts::Cartesian.new(chart_array, :bar => true, :hide_zero => true).draw
