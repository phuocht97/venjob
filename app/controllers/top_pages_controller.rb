class TopPagesController < ApplicationController
  def index
    @total_jobs = Job.all
    @jobs = Job.limit(5).order(created_at: :desc)
    @jobs_of_cities = CityJob.limit(9).group('city_id').order('Count(*) DESC').count
    @jobs_of_industries = IndustryJob.limit(9).group('industry_id').order('Count(*) DESC').count
    @index = 0
  end
end
