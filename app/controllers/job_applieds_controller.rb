class JobAppliedsController < ApplicationController
  before_action :sign_in_validation, only: [:new, :confirmation, :create]

  def new
  end

  def confirmation
    @user = JobApplied.new(apply_params)
    return root_path unless apply_params
  end

  def create
    binding.pry
    @user = JobApplied.new(apply_params)
    return root_path unless @user
    return job_detail_path(apply_params[:job_id]) unless @user.save
  end

  private

  def sign_in_validation
    return if signed_in?
    flash[:warning] = Settings.user.warning_signin
    redirect_to login_path
  end

  def apply_params
    params.require(:job_applied).permit(:name, :email, :job_id, :cv_user)
  end
end
