class City < ApplicationRecord
  has_many :city_jobs
  has_many :jobs, through: :city_jobs
  
end
