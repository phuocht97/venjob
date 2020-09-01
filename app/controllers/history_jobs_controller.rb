class HistoryJobsController < ApplicationController
  before_action :sign_in_favorite_validation, only: [:destroy]
  before_action :sign_in_validation, only: [:index]

  def index
    @count = current_user.histories.count
    @history_jobs = current_user.histories.order_history.page(params[:page]).per(Job::LIMIT_PAGE)
  end

  def destroy
    @job = Job.find_by_id(params[:job_id])
    @unfollow = current_user.remove_history!(params[:job_id])

    respond_to { |format| format.js }

    if request.referer.include?("history")
      @count = current_user.histories.count

      count_on_page = @count % Job::LIMIT_PAGE
      page_number = @count / Job::LIMIT_PAGE
      link_url = request.referer.to_s.split("=")

      return redirect_to link_url[0] + "=" + page_number.to_s if count_on_page == 0 && link_url[1].to_i == page_number + 1

      return redirect_to request.referer if count_on_page == 0
    end
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
