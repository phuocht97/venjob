class ConfirmationsController < ApplicationController

  def new
  end

  def mail_register
    email = params[:confirmation][:email].downcase
    if User.find_by(email: email)
      flash[:danger] = ENV['email_existed']
      redirect_to register_step1_path
    end
    @user = Confirmation.find_or_initialize_by(email: email)
    unless @user.save
      flash[:danger] = ENV['email_format_failed']
      return redirect_to register_step1_path
    end

    ConfirmationMailer.register_email(@user).deliver_later
  end
end
