class Company < ApplicationRecord
  before_save :convert_company
  has_many :jobs

  def convert_company
    self.converted_name = Convert.to_convert("#{name} #{rand(10000)}")
  end
end
