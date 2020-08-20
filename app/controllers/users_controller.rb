class UsersController < ApplicationController
  before_action :sign_in_validation, only: [:update, :my_page, :my_info]

  def my_page
  end

  def my_info
  end

  def update
    if current_user.authenticate(params[:user][:password])
      return respond_to { |format| format.js } unless current_user.update_attributes(user_params)

      flash[:success] = 'Updated Successfully'
      redirect_to my_page_path
    else
      flash.now[:danger] = 'Password is mismatch'
    end
  end

  def registation
    @email = Confirmation.find_by(confirm_token: params[:confirm_token])
    return register_step1_path unless @email
    expiration_day = Time.zone.now - @email.updated_at
    if expiration_day >= 86400
      flash[:danger] = "Link Confirmation is expiration too 24 hours to confirm. Please update your Email again!"
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
    flash[:warning] = "Please Sign In..."
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
