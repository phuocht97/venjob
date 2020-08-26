class ResetPasswordMailer < ActionMailer::Base
  def reset_password(user)
    @user = user
    mail(to: user.email, subject: Settings.email.reset_password)
  end
end
