class UsersController < ApplicationController
  before_action :sign_in_validation, only: [:update, :my_page, :my_info]

  def my_page
  end

  def my_info
  end

  def update
    if current_user.authenticate(params[:user][:password])
      return respond_to { |format| format.js } unless current_user.update_attributes(user_params)

      flash[:success] = Settings.general_notify.update_success
      redirect_to my_page_path
    else
      flash.now[:danger] = Settings.user.password_mismatch
    end
  end

  def registation
    @email = Confirmation.find_by(confirm_token: params[:code])
    return redirect_to register_step1_path unless @email
    if @email.token_expired?
      flash[:danger] = Settings.user.expiration
      redirect_to register_step1_path
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(sign_up_params)
    return respond_to { |format| format.js } unless @user.save
    sign_in @user
    redirect_to my_page_path
  end

  private

  def sign_in_validation
    return if signed_in?
    flash[:warning] = Settings.user.warning_signin
    redirect_to login_path
  end

  def user_params
    params[:user][:password] = change_pass_param[:new_password] if change_pass_param[:new_password].present?
    params.require(:user).permit(:name, :email, :cv_user, :password)
  end

  def change_pass_param
    params.require(:user).permit(:new_password)
  end

  def sign_up_params
    params.require(:user).permit(:name, :email, :cv_user, :password, :password_confirmation)
  end
end
