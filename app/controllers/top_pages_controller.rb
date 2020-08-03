class TopPagesController < ApplicationController
  def index
    @cities = City.all
    @industries = Industry.all
    @total_jobs = Job.count
    @jobs = Job.limit(5).order(created_at: :desc)
    @jobs_of_cities = City.top_city
    @jobs_of_industries = Industry.top_industry
  end
end
