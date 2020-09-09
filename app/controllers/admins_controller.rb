class AdminsController < ApplicationController
  before_action :sign_out_current_user
  before_action :sign_in_validation_admin, only: [:index, :destroy]

  def index
    @cities = City.all
    @industries = Industry.all
    @count_apply_job = JobApplied.count
    @user_apply_job = JobApplied.all.order(updated_at: :desc).page(params[:page]).per(Job::LIMIT_PAGE)

    @days = ['None']
    (Admin::FIRST_DAY..Admin::LAST_DAY).each {|d| @days << d}
    @months = ['None']
    (Admin::FIRST_MONTH..Admin::LAST_MONTH).each {|m| @months << m}
    @years = ['None']
    (Admin::FIRST_YEAR..Admin::LAST_YEAR).each {|y| @years << y}

  end

  def new
    redirect_to admin_page_path if signed_in? && current_user.admin?
  end

  def create
    user = User.find_by(email: params[:admin][:email].downcase, admin: true)
    if user && user.authenticate(params[:admin][:password])
      sign_in user
      redirect_to admin_page_path
    else
      flash.now[:danger] = Settings.user.sign_in.failed
      render :new
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  def download_csv
    @user_apply_job = JobApplied.all.order(updated_at: :desc)
    respond_to do |format|
      format.csv { send_data @user_apply_job.to_csv, filename: "test-#{Date.today}.csv"}
    end
  end

  private

  def sign_out_current_user
    sign_out if signed_in? && current_user.admin.nil?
  end

  def sign_in_validation_admin
    return if signed_in? && current_user.admin?
    store_location
    flash[:warning] = Settings.user.warning_signin
    redirect_to admin_login_path
  end
end
