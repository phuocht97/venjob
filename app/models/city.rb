class City < ApplicationRecord
  before_save :set_converted_name

  has_many :city_jobs
  has_many :jobs, through: :city_jobs

  VIETNAM = 1
  FOREIGN = 0

  scope :top_city, -> { joins(:jobs).group(:city_id).order('count(job_id) DESC').limit(9) }
  scope :location, ->(number) { joins(:jobs).group(:city_id).order('count(job_id) DESC').where(location: number) }

  private

  def set_converted_name
    self.converted_name = convert_attribute(name)
  end
end
