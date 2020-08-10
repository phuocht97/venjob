class CitiesController < ApplicationController
  def index
    @cities_vietnam = City.location(City::VIETNAM)
    @cities_international = City.location(City::FOREIGN)
  end
end
