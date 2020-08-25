class JobAppliedsController < ApplicationController
  before_action :sign_in_validation, only: [:new, :confirmation, :create]
  before_action :find_job_id, only: [:new]

  def new
  end

  def show
    arr_job_id = current_user.job_applieds.pluck(:job_id)
    @jobs = Job.where(id: arr_job_id).order(updated_at: :asc)
  end

  def confirmation
    @user = current_user.job_applieds.new(apply_params)
    @user.cv_user = current_user.cv_user if apply_params[:cv_user].blank?
    if @user.invalid?
      flash[:danger] = @user.errors.full_messages.join('<br>')
      redirect_to apply_job_path(job_id: apply_params[:job_id])
    end
  end

  def create
    @job = Job.find_by(id: apply_params[:job_id])
    @user = current_user.job_applieds.new(apply_params)
    @user.cv_user.retrieve_from_cache!(apply_params[:cv_user])
    if @user.save
      JobAppliedMailer.apply_job(@user, @job).deliver_later
      JobAppliedMailer.apply_job(ENV['GMAIL_USERNAME']).deliver_later
    end
  end

  private

  def sign_in_validation
    return if signed_in?
    flash[:warning] = "Please Sign In..."
    redirect_to login_path
  end

  def apply_params
    params.require(:job_applied).permit(:name, :email, :cv_user, :job_id)
  end

  def find_job_id
    return redirect_to jobs_path unless Job.find_by(id: params[:job_id])
  end
end
