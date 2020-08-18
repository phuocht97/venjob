class Company < ApplicationRecord
  before_save :set_converted_name

  has_many :jobs

  private

  def set_converted_name
    self.converted_name = convert_attribute(name)
  end
end
