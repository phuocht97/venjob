class CitiesController < ApplicationController
  def index
    @cities_vietnam = City.location(1)
    @cities_international = City.location(0)
  end
end
