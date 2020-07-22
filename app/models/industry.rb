class Industry < ApplicationRecord
  has_many :industry_jobs
  has_many :jobs, through: :industry_jobs
end
