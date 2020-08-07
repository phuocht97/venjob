class JobsController < ApplicationController
  before_action :use_variables

  def index
    @jobs_list = Job.all_job.page(params[:page]).per(20)
  end

  def city_jobs
    @city = City.find_by(converted_name: params[:converted_name])
    @jobs_list = @city.jobs.all_job.page(params[:page]).per(20)
    @result_for_job = @city.jobs.count
  end

  def industry_jobs
    @industry = Industry.find_by(converted_name: params[:converted_name])
    @jobs_list = @industry.jobs.all_job.page(params[:page]).per(20)
    @result_for_job = @industry.jobs.count
  end

  def use_variables
    @cities = City.all
    @industries = Industry.all
    @total_job = Job.count
  end
end
