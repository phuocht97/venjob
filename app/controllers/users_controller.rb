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

  def new
    @email = User.new
  end

  def create
    @email = User.new(email: params[:user][:email])
    if @email.save
      UserMailer.register_email(params[:user][:email]).deliver_later
      redirect_to mail_register_path
    else
      redirect_to register_begin_path
    end
  end

  def mail_register
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
end
