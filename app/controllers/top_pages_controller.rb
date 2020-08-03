class TopPagesController < ApplicationController
  def index
    @cities = City.all
    @industries = Industry.all
    @total_jobs = Job.count
    @jobs = Job.limit(5).order(created_at: :desc)
    @jobs_of_cities = CityJob.top_city
    @jobs_of_industries = IndustryJob.limit(9).group('industry_id').order('Count(*) DESC').count
  end
end
