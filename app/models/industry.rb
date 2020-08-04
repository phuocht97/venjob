class Industry < ApplicationRecord
  has_many :industry_jobs
  has_many :jobs, through: :industry_jobs

  def self.top_industry
    joins(:jobs).group(:industry_id).order('count(job_id) DESC').limit(9)
  end
end
