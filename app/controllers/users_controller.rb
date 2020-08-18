class UsersController < ApplicationController
  before_action :sign_in_validation, only: [:update, :my_page, :my_info]
  def my_page
  end

  def my_info
  end

  def update
    user_params.delete(:password) if user_params[:password].blank?
    if BCrypt::Password.new(current_user.password_digest) != condition_update[:oldpassword]
      flash.now[:danger] = 'Old Password is mismatch'
    else
      if current_user.update_attributes(user_params)
        flash[:success] = 'Updated Successfully'
        redirect_to my_page_path
      else
        respond_to do |format|
          format.js
        end
      end
    end
  end

  private

  def sign_in_validation
    return if signed_in?
    flash[:warning] = "Please Sign In..."
    redirect_to login_path
  end

  def user_params
    params.require(:user).permit(:name, :email, :cv_user, :password)
  end

  def condition_update
    params.require(:user).permit(:oldpassword)
  end
end
