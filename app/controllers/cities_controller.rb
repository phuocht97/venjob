class CitiesController < ApplicationController
    VIETNAM = 1
    FOREIGN = 0
  def index
    @cities_vietnam = City.location(City::VIETNAM)
    @cities_international = City.location(City::FOREIGN)
  end
end
