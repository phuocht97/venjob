class Industry < ApplicationRecord
  before_save :convert_attribute
  has_many :industry_jobs
  has_many :jobs, through: :industry_jobs

  scope :top_industry, -> { joins(:jobs).group(:industry_id).order('count(job_id) DESC').limit(9) }
  scope :all_industry, -> { joins(:jobs).group(:industry_id).order('count(job_id) DESC') }

  private

  def normalize_attribute
    "#{name} #{rand(10000)}"
  end
end
