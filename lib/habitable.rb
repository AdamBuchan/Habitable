require "habitable/version"
require 'nestoria/api'
require 'geocoder'
require 'httparty'
require 'OpenWeather'

module Habitable
  
  def self.outcode postcode
    postcode.split(' ').first
  end

  def self.coords_lat postcode
    Geocoder.search(postcode)[0].latitude
  end

  def self.coords_lng postcode
    Geocoder.search(postcode)[0].longitude
  end

  def self.house_prices postcode
    code = outcode postcode
    prices = Nestoria::Api.new(:uk).metadata :place_name => code

    last_year_price = prices['metadata'][11]['data']['2012_m1']['avg_price']
    this_year_price = prices['metadata'][11]['data']['2013_m9']['avg_price']
    this_year_price.to_f/last_year_price.to_f
  end

  def self.crimes postcode
    Geocoder.configure(:timeout => 15)
    lat = coords_lat postcode
    lng = coords_lng postcode
    crime = HTTParty.get("http://data.police.uk/api/crimes-street/all-crime?lat=#{lat}&lng=#{lng}").length

    worst_lat = coords_lat 'EC1R 5EN'
    worst_lng = coords_lng 'EC1R 5EN'
    worst_crime = HTTParty.get("http://data.police.uk/api/crimes-street/all-crime?lat=#{worst_lat}&lng=#{worst_lng}").length

    worst_crime.to_f / crime.to_f
  end

  def self.weather postcode
    Geocoder.configure(:timeout => 15)
    lat = coords_lat postcode
    lng = coords_lng postcode
    result = HTTParty.get("http://openweathermap.org/data/2.0/find/city?lat=#{lat}&lon=#{lng}&cnt=1&mode=json")
    temp = JSON.parse(result)['list'][0]['main']['temp']

    hottest_result = HTTParty.get("http://openweathermap.org/data/2.0/find/city?lat=51.512273&lon=-0.079638&cnt=1&mode=json")
    hottest_temp = JSON.parse(hottest_result)['list'][0]['main']['temp']

    hottest_temp.to_f/temp.to_f
  end

  def self.score postcode
    h = house_prices postcode
    c = crimes postcode
    w = weather postcode

    [20 * h, 33].min + [10 * c, 33].min + [33 * w, 33].min
  end

end
