class CitiesController < ApplicationController
  def index
    @cities_vietnam = City.all_city.where('location = 1')
    @cities_international = City.all_city.where('location = 0')
  end
end
