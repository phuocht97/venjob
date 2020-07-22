class FavoriteJob < ApplicationRecord
  belongs_to :user
  belongs_to :job
end
