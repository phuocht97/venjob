class Company < ApplicationRecord
  before_save :convert_attribute
  has_many :jobs

  private

  def normalize_attribute
    name
  end
end
