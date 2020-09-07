class FavoriteJobsController < ApplicationController
  before_action :sign_in_validation, only: %i[create destroy index]

  def index
    page = Integer(params[:page] || "1") rescue 0

    return redirect_to favorite_jobs_path unless page.positive?

    @count = current_user.favorite_jobs.count
    @favorited_jobs = current_user.favorite_jobs.order_favorite.page(page).per(Job::LIMIT_PAGE)
  end

  def create
    return if current_user.favorite_jobs.exists?(job_id: params[:job_id])
    @favorite = current_user.favorite!(params[:job_id])
    respond_to { |format| format.js }
  end

  def destroy
    @unfavorite = current_user.unfavorite!(params[:job_id])

    if request.referer.include?("favorite")
      @count = current_user.favorite_jobs.count
      current_page_count = @count % Job::LIMIT_PAGE
      remain_page = @count / Job::LIMIT_PAGE

      return redirect_to favorite_jobs_path(page: remain_page) if current_page_count == Job::DIVISIBLE && params[:page] == remain_page + 1
      return redirect_to favorite_jobs_path(page: remain_page) if current_page_count == Job::DIVISIBLE
    end

    respond_to { |format| format.js }
  end
end
