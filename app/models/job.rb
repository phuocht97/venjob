class Job < ApplicationRecord
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

  scope :limit_job, -> { includes(:cities, :company).order(created_at: :desc).limit(5) }
  scope :all_job, -> { limit(20).order(created_at: :desc) }

  def company_name
    company&.name
  end
end

