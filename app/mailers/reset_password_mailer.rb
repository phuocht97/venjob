class ResetPasswordMailer < ActionMailer::Base
  def reset_password(user)
    @user = user
    mail(to: user.email, subject: 'VeNJOB Password Assistance')
  end
end
