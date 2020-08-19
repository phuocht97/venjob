class ConfirmationsController < ApplicationController

  def new
    @user = Confirmation.new
  end

  def create
    @user = Confirmation.new(email: params[:confirmation][:email].downcase)
    user_email = User.find_by(email: params[:confirmation][:email].downcase)
    if user_email.blank?
      return respond_to { |format| format.js } unless @user.save
      ConfirmationMailer.register_email(params[:confirmation][:email].downcase, @user.confirm_token).deliver_later
      redirect_to mail_register_path
    else
      flash[:danger] = 'Email existed. Please change !!!'
      redirect_to register_path
    end
  end
end
