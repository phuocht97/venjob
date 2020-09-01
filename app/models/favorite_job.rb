class FavoriteJob < ApplicationRecord
  belongs_to :user
  belongs_to :job

  scope :order_favorite, -> { order(updated_at: :desc) }
end
