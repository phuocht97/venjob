class JobAppliedMailer < ActionMailer::Base
  def apply_job(user, job)
    @job = job
    @user = user
    mail(to: user.email, subject: Settings.email.job_applied)
  end

  def sending_admin(user, job, email)
    @job = job
    @user = user
    mail(to: email, subject: Settings.email.job_applied)
  end
end
