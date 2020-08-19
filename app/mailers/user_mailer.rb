class UserMailer < ActionMailer::Base
  def register_email(email)
    @email = email
    mail(to: @email, subject: 'Welcome To VeNJOB! Confirm Your Email')
  end
end
