class CitiesController < ApplicationController
  def index
    @vietnam = City.location(City::VIETNAM)
    @international = City.location(City::FOREIGN)
  end
end
