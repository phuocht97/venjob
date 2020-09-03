class FavoriteJobsController < ApplicationController
  before_action :sign_in_validation, only: %i[create destroy index]

  def index
    if params[:page].present? || params[:page] == ""
      return redirect_to favorite_jobs_path, flash: {warning: Settings.user.favorite_job.validate_page } if params[:page].to_i <= 0 || params[:page].scan(/\D+/).present?
    end
    @count = current_user.favorite_jobs.count
    @favorited_jobs = current_user.favorite_jobs.order_favorite.page(params[:page]).per(Job::LIMIT_PAGE)
  end

  def create
    return if current_user.favorite_jobs.exists?(job_id: params[:job_id])
    @follow = current_user.favorite!(params[:job_id])
    respond_to { |format| format.js }
  end

  def destroy
    @unfollow = current_user.unfavorite!(params[:job_id])

    if request.referer.include?("favorite")
      @count = current_user.favorite_jobs.count

      count_on_page = @count % Job::LIMIT_PAGE
      page_number = @count / Job::LIMIT_PAGE
      link_url = request.referer.to_s.split("=")

      return redirect_to link_url[0] + "=" + page_number.to_s if count_on_page == Job::DIVISIBLE && link_url[1].to_i == page_number + 1

      return redirect_to request.referer if count_on_page == Job::DIVISIBLE
    end

    respond_to { |format| format.js }
  end

  private

  def sign_in_validation
    return if signed_in?
    store_location
    flash[:warning] = Settings.user.warning_signin
    redirect_to login_path
  end
end
