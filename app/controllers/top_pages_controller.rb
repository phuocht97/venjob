class TopPagesController < ApplicationController
  def index
    @total_jobs = Job.ids
    @jobs = Job.limit(5).order(created_at: :desc)
    @companies = Company.all
    @total_cities = CityJob.all.group('city_id').count
  end
end
