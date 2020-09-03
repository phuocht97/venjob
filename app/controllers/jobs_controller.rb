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
    if signed_in?
      @is_job_applied = current_user.job_applieds.pluck(:job_id).include?@job.id

      founded_history = current_user.histories.find_by(job_id: params[:id])
      return founded_history.update(updated_at: Time.current.utc) if founded_history.present?

      history = current_user.histories.create!(job_id: params[:id])

      history_jobs = current_user.histories.order_history
      history_jobs.last.destroy if history_jobs.count >= Job::LIMIT_HISTORY
    end
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

