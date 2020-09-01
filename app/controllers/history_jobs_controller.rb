class HistoryJobsController < ApplicationController
  before_action :sign_in_favorite_validation, only: [:destroy]
  before_action :sign_in_validation, only: [:index]

  def index
    @count = current_user.histories.count
    @history_jobs = current_user.histories.order_history
  end

  private

  def sign_in_favorite_validation
    return if signed_in?
    session[:return_to] = request.referer
    flash[:warning] = Settings.user.warning_signin
    redirect_to login_path
  end

  def sign_in_validation
    return if signed_in?
    store_location
    flash[:warning] = Settings.user.warning_signin
    redirect_to login_path
  end
end
