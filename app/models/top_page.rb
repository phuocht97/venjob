class TopPage < ApplicationRecord
  # scope :limit_job, -> { order('created_at DESC') }
  scope :limit_job, -> { order('title DESC') }
  # scope :limit_job, order(created_at: :desc).limit(5)
end
