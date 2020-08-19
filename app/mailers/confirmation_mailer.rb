class ConfirmationMailer < ActionMailer::Base
  def register_email(email, confirm_token)
    @email = email
    @confirm_token = confirm_token
    mail(to: @email, subject: 'Welcome To VeNJOB! Confirm Your Email')
  end
end
