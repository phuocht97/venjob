class JobAppliedsController < ApplicationController
  before_action :sign_in_validation, only: %i[new confirmation create show]
  before_action :find_job_id, only: [:new]

  def new
    session[:job_id] = params[:job_id]
    if session[:job_applied].present?
      user_name = session[:job_applied]['name']
      user_email = session[:job_applied]['email']
    end

    session[:job_id] ||= session[:get_job_id]
    user_name ||= current_user.name
    user_email ||= current_user.email

    founded_application = JobApplied.exists?(user_id: current_user.id, job_id: session[:job_id])
    return redirect_to job_detail_path(session[:job_id]) if founded_application

    @job_applied = current_user.job_applieds.new(name: user_name,
                                                 email: user_email)
  end

  def show
    @jobs = Job.applied_job(current_user.id).page(params[:page]).per(Job::LIMIT_PAGE)
  end

  def confirmation
    session[:get_job_id] = session[:job_id]
    @job_applied = current_user.job_applieds.new(apply_params)
    session[:job_applied] = @job_applied

    @job_applied.cv_user = current_user.cv_user if apply_params[:cv_user].blank?
    @job_applied.job_id = session[:get_job_id] if @job_applied.job_id.blank?

    if @job_applied.invalid?
      flash.now[:danger] = @job_applied.errors.full_messages.join('<br>')
      render :new
    end
  end

  def create
    @job = Job.find_by(id: session[:get_job_id])
    @job_applied = current_user.job_applieds.new(apply_params)
    @job_applied.job_id = session[:get_job_id] if @job_applied.job_id.blank?
    @job_applied.cv_user.retrieve_from_cache!(apply_params[:cv_user])
    if @job_applied.save
      JobAppliedMailer.apply_job(@job_applied, @job).deliver_later
      JobAppliedMailer.sending_admin(@job_applied, @job, ENV['GMAIL_USERNAME']).deliver_later
    end
    session.delete(:job_applied)
  end

  private

  def sign_in_validation
    return if signed_in?
    store_location
    flash[:warning] = Settings.user.warning_signin
    redirect_to login_path
  end

  def apply_params
    params.require(:job_applied).permit(:name, :email, :cv_user)
  end

  def find_job_id
    return redirect_to jobs_path unless Job.find_by(id: params[:job_id])
  end
end
