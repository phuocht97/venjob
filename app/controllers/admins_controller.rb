class AdminsController < ApplicationController

  def index
    @cities = City.all
    @industries = Industry.all
    @count_apply_job = JobApplied.count
    @user_apply_job = JobApplied.all.order(updated_at: :desc).page(params[:page]).per(Job::LIMIT_PAGE)
    @months = [['None', '']]
    (1..12).each {|m| @months << [Date::MONTHNAMES[m], m]}
    binding.pry
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

  def sign_out_current_user
    sign_out if signed_in? && current_user.admin.nil?
  end
end
