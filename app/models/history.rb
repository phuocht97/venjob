class History < ApplicationRecord
  belongs_to :user
  belongs_to :job

  scope :order_history, -> { order(updated_at: :desc) }
end
