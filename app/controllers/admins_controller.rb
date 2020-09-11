class AdminsController < ApplicationController
  before_action :sign_out_current_user
  before_action :remove_session, only:[:index]
  before_action :sign_in_validation_admin, only: [:index, :destroy, :search]

  def index
    @cities = City.all
    @industries = Industry.all
    @apply_job = JobApplied.includes(job: :cities).includes(job: :industries)

    @user_apply_job = @apply_job.order(updated_at: :desc).page(params[:page]).per(Job::LIMIT_PAGE)

    @days = []
    (Admin::FIRST_DAY..Admin::LAST_DAY).each {|d| @days << d}
    @months = []
    (Admin::FIRST_MONTH..Admin::LAST_MONTH).each {|m| @months << m}
    @years = []
    (Admin::FIRST_YEAR..Admin::LAST_YEAR).each {|y| @years << y}
  end

  def search
    @cities = City.all
    @industries = Industry.all
    if params[:commit] == 'Search'
      session[:input_email] = params[:admin][:email]
      session[:input_city] = params[:admin][:city_opt]
      session[:input_industry] = params[:admin][:industry_opt]

      from_day = params[:admin][:from_day]
      from_month = params[:admin][:from_month]
      from_year = params[:admin][:from_year]
      session[:from_datetime] = "#{from_year}/#{from_month}/#{from_day}"

      params[:admin][:to_day].blank? ? to_day = Admin::LAST_DAY : to_day = params[:admin][:to_day]
      params[:admin][:to_month].blank? ? to_month = Admin::LAST_MONTH : to_month = params[:admin][:to_month]
      params[:admin][:to_year].blank? ? to_year = Admin::LAST_YEAR : to_year = params[:admin][:to_year]
      session[:to_datetime] = "#{to_year}/#{to_month}/#{to_day}"
    end

    @apply_job = JobApplied.includes(job: :cities).includes(job: :industries).email(session[:input_email]).city(session[:input_city]).industry(session[:input_industry]).datetime(session[:from_datetime], session[:to_datetime])

    @user_apply_job = @apply_job.order(updated_at: :desc).page(params[:page]).per(Job::LIMIT_PAGE)

    @days = []
    (Admin::FIRST_DAY..Admin::LAST_DAY).each {|d| @days << d}
    @months = []
    (Admin::FIRST_MONTH..Admin::LAST_MONTH).each {|m| @months << m}
    @years = []
    (Admin::FIRST_YEAR..Admin::LAST_YEAR).each {|y| @years << y}
  end

  def download_csv
    input_email = session[:input_email]
    input_city = session[:input_city]
    input_industry = session[:input_industry]
    from_datetime = session[:from_datetime]
    to_datetime = session[:to_datetime]

    @apply_job = JobApplied.includes(job: :cities).includes(job: :industries).email(input_email).city(input_city).industry(input_industry).datetime(from_datetime, to_datetime)

    @apply_job = JobApplied.includes(job: :cities).includes(job: :industries) if @apply_job.blank?
    @user_apply_job = @apply_job.order(updated_at: :desc)
    csv = ExportCsvService.new(@user_apply_job, JobApplied::CSV_ATTRIBUTES)
    respond_to do |format|
      format.csv { send_data csv.perform,
                   filename: "applied-jobs-#{Date.today}.csv"}
    end
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

  private

  def remove_session
    reset_session
  end

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
