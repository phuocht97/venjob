class ResetPasswordsController < ApplicationController

  def reset_password
  end

  def sending_email
    @user = User.find_by(email: params[:reset_password][:email].downcase)
    unless @user
      flash[:danger] = ENV['sending_email_failed']
      redirect_to reset_password_step1_path
    else
      forgot_token = Digest::SHA1.hexdigest(SecureRandom.urlsafe_base64)
      @user.update_attribute(:remember_token, forgot_token)
      ResetPasswordMailer.reset_password(@user).deliver_later
      flash[:success] = ENV['sending_email_success']
      redirect_to reset_password_step1_path
    end
  end

  def edit
    @user = User.find_by(remember_token: params[:token])
    return redirect_to reset_password_step1_path unless @user && params[:token]
    if @user.token_expired?
      flash[:danger] = ENV['expiration']
      redirect_to register_step1_path
    end
  end

  def update
    @user = User.find_by(email: params[:user][:email])
    unless @user.update_attributes(forgot_pass_params)
      flash[:danger] = ENV['update_reset_pass']
      redirect_to reset_password_final_path(token: @user.remember_token)
    else
      sign_in @user
      flash[:success] = ENV['update_success']
      redirect_to my_page_path
    end
  end

  private

  def forgot_pass_params
    params.require(:user).permit( :password, :password_confirmation)
  end
end
