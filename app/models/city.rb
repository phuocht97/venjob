class City < ApplicationRecord
  has_many :city_jobs
  has_many :jobs, through: :city_jobs

  scope :top_city, -> { joins(:jobs).group(:city_id).order('count(job_id) DESC').limit(9) }
  scope :all_city, -> { joins(:jobs).group(:city_id).order('count(job_id) DESC') }
  scope :vietnam, -> { where('location = 1') }
  scope :international, -> { where('location = 0') }
end
