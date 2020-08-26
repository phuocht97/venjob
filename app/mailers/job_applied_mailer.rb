class JobAppliedMailer < ActionMailer::Base
  def apply_job(user, job)
    @job = job
    @user = user
    mail(to: user.email, subject: Settings.email.job_applied)
  end
end
