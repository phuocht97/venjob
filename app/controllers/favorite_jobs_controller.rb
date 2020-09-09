class FavoriteJobsController < ApplicationController
  before_action :sign_in_validation, only: %i[create destroy index]

  def index
    @count = current_user.favorite_jobs.count
    return if @count.zero?

    page = Integer(params[:page] || "1") rescue 0
    return redirect_to favorite_jobs_path unless page.positive?

    @favorited_jobs = current_user.favorite_jobs.includes(job: :cities).order_favorite.page(page).per(Job::LIMIT_PAGE)
    return render_error_404 if @favorited_jobs.blank?
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

      if current_page_count == Job::DIVISIBLE
        return redirect_to favorite_jobs_path(page: remain_page) if params[:page].to_i == remain_page + 1
        redirect_to favorite_jobs_path(page: params[:page])
      end
    end

    respond_to { |format| format.js }
  end
end
