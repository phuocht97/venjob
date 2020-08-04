class City < ApplicationRecord
  has_many :city_jobs
  has_many :jobs, through: :city_jobs

  def self.top_city
    joins(:jobs).group(:city_id).order('count(job_id) DESC').limit(9)
  end
  def self.all_city
    joins(:jobs).group(:city_id).order('count(job_id) DESC')
  end
end
