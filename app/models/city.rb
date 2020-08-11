class City < ApplicationRecord
  before_save :convert_attribute
  has_many :city_jobs
  has_many :jobs, through: :city_jobs

  VIETNAM = 1
  FOREIGN = 0

  scope :top_city, -> { joins(:jobs).group(:city_id).order('count(job_id) DESC').limit(9) }
  scope :location, ->(number) { joins(:jobs).group(:city_id).order('count(job_id) DESC').where(location: number) }

  private

  def normalize_attribute
    name
  end
end
