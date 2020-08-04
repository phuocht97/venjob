class CitiesController < ApplicationController
  def index
    @cities_vietnam = City.all_city.vietnam
    @cities_international = City.all_city.international
  end
end
