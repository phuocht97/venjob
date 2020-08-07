class CitiesController < ApplicationController
  VIETNAM = 1
  FOREIGN = 0
  def index
    @cities_vietnam = City.location(VIETNAM)
    @cities_international = City.location(FOREIGN)
  end
end
