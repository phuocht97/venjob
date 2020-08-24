class ConfirmationMailer < ActionMailer::Base
  def register_email(user)
    @user = user
    mail(to: user.email, subject: 'Welcome To VeNJOB! Confirm Your Email')
  end
end
