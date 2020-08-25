class JobAppliedMailer < ActionMailer::Base
  def apply_job(user, job)
    @job = job
    @user = user
    mail(to: user.email, subject: 'Thank your for apply with VeNJOB')
  end
end
