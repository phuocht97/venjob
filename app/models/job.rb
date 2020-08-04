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

  def company_name
    company&.name
  end
end

