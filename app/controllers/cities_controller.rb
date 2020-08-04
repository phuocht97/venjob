class CitiesController < ApplicationController
  def index
    @cities_vietnam = City.vietnam
    @cities_international = City.international
  end
end
