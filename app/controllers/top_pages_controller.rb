class TopPagesController < ApplicationController
  def index
    @cities = City.all
    @industries = Industry.all
    @total_jobs = Job.count
    @jobs = Job.limit_job
    @jobs_of_cities = City.top_city
    @jobs_of_industries = Industry.top_industry
  end
end
