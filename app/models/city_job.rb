class CityJob < ApplicationRecord
  belongs_to :city
  belongs_to :job

  def self.top_city
    limit(9).group('city_id').order('Count(*) DESC').count
  end
end
