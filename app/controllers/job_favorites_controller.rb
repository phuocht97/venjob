class JobFavoritesController < ApplicationController
  before_action :sign_in_validation, only: [:create, :destroy]
  before_action :find_job_id, only: [:new]

  def create

  end

  def destroy

  end

  private

  def sign_in_validation
    return if signed_in?
    store_location
    flash[:warning] = Settings.user.warning_signin
    redirect_to login_path
  end
end
