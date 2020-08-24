class ResetPasswordsController < ApplicationController
  before_action :find_token_param, only: [:edit]

  def reset_password
  end

  def sending_email
    @user = User.find_by(email: params[:reset_password][:email].downcase)
    unless @user
      flash[:danger] = Settings.user.reset_password.failed
    else
      forgot_token = Digest::SHA1.hexdigest(SecureRandom.urlsafe_base64)
      @user.update_attribute(:remember_token, forgot_token)
      ResetPasswordMailer.reset_password(@user).deliver_later
      flash[:success] = Settings.user.reset_password.success
    end
    redirect_to reset_password_step1_path
  end

  def edit
    @user = User.find_by(remember_token: params[:token])
    return redirect_to reset_password_step1_path unless @user
    if @user.token_expired?
      flash[:danger] = Settings.user.expiration
      redirect_to register_step1_path
    end
  end

  def update
    @user = User.find_by(email: params[:user][:email])
    if @user.update_attributes(forgot_pass_params)
      sign_in @user
      flash[:success] = Settings.general_notify.update_success
      redirect_to my_page_path
    else
      flash[:danger] = Settings.user.reset_password.update_reset_pass
      redirect_to reset_password_final_path(token: @user.remember_token)
    end
  end

  private

  def find_token_param
    return redirect_to reset_password_step1_path unless params[:token]
  end

  def forgot_pass_params
    params.require(:user).permit( :password, :password_confirmation)
  end
end
