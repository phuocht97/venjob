class JobsController < ApplicationController
  def index
    @cities = City.all
    @industries = Industry.all
    @total_job = Job.count
    @jobs_list = Job.all_job.page(params[:page]).per(20)
  end
  def city_jobs
    @cities = City.all
    @industries = Industry.all
    @city = City.find(params[:id])
    @jobs_list = @city.jobs.all_job.page(params[:page]).per(20)
    @total_job = Job.count
    @result_for_job = @city.jobs.count
  end
end
