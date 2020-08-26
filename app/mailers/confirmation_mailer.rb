class ConfirmationMailer < ActionMailer::Base
  def register_email(user)
    @user = user
    mail(to: user.email, subject: Settings.email.confirmation)
  end
end
