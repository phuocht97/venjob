class User < ApplicationRecord
  has_many :favorite_jobs
  has_many :jobs, through: :favorite_jobs
  has_many :job_applieds
  has_many :jobs, through: :job_applieds
  has_many :histories
  has_many :jobs, through: :histories
end
