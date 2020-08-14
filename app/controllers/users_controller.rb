class UsersController < ApplicationController
  before_action :signed_in_user, only: [:update, :my_page, :my_info]
  def my_page
  end

  def my_info
  end

  def update
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

  def signed_in_user
    unless signed_in?
      flash[:warning] = "Please Sign In..."
      redirect_to login_path
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :cv_user)
  end

  def condition_update
    params.require(:user).permit(:oldpassword)
  end
end
