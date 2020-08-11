class Job < ApplicationRecord
  before_save :convert_attribute
  belongs_to :company
  has_many :city_jobs
  has_many :cities, through: :city_jobs

  has_many :industry_jobs
  has_many :industries, through: :industry_jobs

  has_many :favorite_jobs
  has_many :users, through: :favorite_jobs

  has_many :job_applieds
  has_many :users, through: :job_applieds

  has_many :histories
  has_many :users, through: :histories

  LIMIT_PAGE = 20

  scope :limit_job, -> { includes(:cities, :company).order(created_at: :desc).limit(5) }

  def company_name
    company&.name
  end

  private

  def normalize_attribute
    "#{title} #{rand(10000)}"
  end
end

