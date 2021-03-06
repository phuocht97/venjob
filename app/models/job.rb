class Job < ApplicationRecord
  before_save :set_converted_name

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
  LIMIT_HISTORY = 20
  DIVISIBLE = 0

  scope :limit_job, -> { includes(:cities, :company).order(created_at: :desc).limit(5) }

  def company_name
    company&.name
  end

  def converted_company_name
    company&.converted_name
  end

  def format_desc
    description.truncate_words(250)
  end

  private

  def set_converted_name
    self.converted_name = convert_attribute(title)
  end
end

