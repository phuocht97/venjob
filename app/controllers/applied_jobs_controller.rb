class AppliedJobsController < ApplicationController
  before_action :sign_in_validation, only: %i[new confirmation create show]
  before_action :validate_apply_job, only: %i[new confirmation create]

  def new
    apply_info = session[:apply_job] || {}
    apply_info[:job_id] = params[:job_id]
    apply_info[:name] ||= current_user.name
    apply_info[:email] ||= current_user.email

    session[:apply_job] = {:job_id => apply_info[:job_id]}
    @job_applied = current_user.job_applieds.new(name: apply_info[:name],
                                                 email: apply_info[:email])

    @job_applied.cv_user.retrieve_from_cache!(session[:cv]) if session[:cv].present?
    @job_applied.cv_user = current_user.cv_user if @job_applied.cv_user.blank?
  end

  def show
    @applied_jobs = current_user.job_applieds.order(updated_at: :desc).page(params[:page]).per(Job::LIMIT_PAGE)
  end

  def confirmation
    @job_applied = current_user.job_applieds.new(apply_params)
    @job_applied.job_id = session[:apply_job]['job_id'] if @job_applied.job_id.blank?
    @job_applied.cv_user = current_user.cv_user if @job_applied.cv_user.blank?

    if @job_applied.invalid?
      flash.now[:danger] = @job_applied.errors.full_messages.join('<br>')
      render :new
    end
    session[:apply_job] = @job_applied
    session[:cv] = @job_applied.cv_user.cache_name
  end

  def create
    @job = Job.find_by(id: session[:apply_job]['job_id'])
    @job_applied = current_user.job_applieds.new(apply_params)
    @job_applied.job_id = @job.id if @job_applied.job_id.blank?
    @job_applied.cv_user.retrieve_from_cache!(apply_params[:cv_user])
    if @job_applied.save
      AppliedJobMailer.apply_job(@job_applied, @job).deliver_later
      AppliedJobMailer.sending_admin(@job_applied, @job, ENV['GMAIL_USERNAME']).deliver_later
      session.delete(:apply_job)
    else
      flash[:danger] = @job_applied.errors.full_messages.join('<br>')
      redirect_to apply_job_path(job_id: session[:apply_job]['job_id'])
    end
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

  def validate_apply_job
    job_id = params[:job_id] || session[:apply_job].try(:[], 'job_id')
    return redirect_to jobs_path, flash: { warning: 'Job not found!'} unless Job.find_by_id(job_id)

    job_applied = JobApplied.exists?(user_id: current_user.id, job_id: job_id)
    return redirect_to job_detail_path(job_id), flash: { info: 'You applied for job'} if job_applied
  end
end
