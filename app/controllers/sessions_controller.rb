class SessionsController < ApplicationController

  def new
    return redirect_to admin_page_path if signed_in? && current_user.admin?
    redirect_to my_page_path if signed_in? && current_user.admin.nil?
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase, admin: nil)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or my_page_path
    else
      flash.now[:danger] = Settings.user.sign_in.failed
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
