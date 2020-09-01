class SessionsController < ApplicationController

  def new
    redirect_to my_page_path if signed_in?
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
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
