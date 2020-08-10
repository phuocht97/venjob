class Industry < ApplicationRecord
  before_save :convert_industry
  has_many :industry_jobs
  has_many :jobs, through: :industry_jobs

  scope :top_industry, -> { joins(:jobs).group(:industry_id).order('count(job_id) DESC').limit(9) }
  scope :all_industry, -> { joins(:jobs).group(:industry_id).order('count(job_id) DESC') }

  def convert_industry
    self.converted_name = Convert.to_convert("#{name} #{rand(10000)}")
  end
end
