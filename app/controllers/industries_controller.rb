class IndustriesController < ApplicationController
  def index
    @industries = Industry.all_industry
  end
end
