class FavoriteJob < ApplicationRecord
  belongs_to :user
  belongs_to :job

  scope :order_favorite, -> { order("favorite_jobs.updated_at DESC") }
end
