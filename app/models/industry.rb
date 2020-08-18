class Industry < ApplicationRecord
  before_save :set_converted_name

  has_many :industry_jobs
  has_many :jobs, through: :industry_jobs

  scope :top_industry, -> { joins(:jobs).group(:industry_id).order('count(job_id) DESC').limit(9) }
  scope :all_industry, -> { joins(:jobs).group(:industry_id).order('count(job_id) DESC') }

  private

  def set_converted_name
    self.converted_name = convert_attribute(name)
  end
end
