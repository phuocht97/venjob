class JobsController < ApplicationController
  before_action :set_job, only: [:show]
  before_action :general_variables

  def index
    @jobs_list = Job.all.page(params[:page]).per(Job::LIMIT_PAGE)
  end

  def city_jobs
    @city = City.find_by(converted_name: params[:converted_name])
    @jobs_list = @city.jobs.page(params[:page]).per(Job::LIMIT_PAGE)
    @result_for_job = @city.jobs.count
  end

  def industry_jobs
    @industry = Industry.find_by(converted_name: params[:converted_name])
    @jobs_list = @industry.jobs.page(params[:page]).per(Job::LIMIT_PAGE)
    @result_for_job = @industry.jobs.count
  end

  def company_jobs
    @company = Company.find_by(converted_name: params[:converted_name])
    @jobs_list = @company.jobs.page(params[:page]).per(Job::LIMIT_PAGE)
    @result_for_job = @company.jobs.count

    redirect_to jobs_path unless @company
  end

  def show
    session.delete(:job_applied)
    return redirect_to jobs_path unless @job
    @user = JobApplied.where(user_id: current_user.id, job_id: params[:id]) if signed_in?
  end

  private

  def set_job
    @job ||= Job.find_by_id(params[:id])
  end

  def general_variables
    @cities = City.all
    @industries = Industry.all
    @total_job = Job.count
  end
end

