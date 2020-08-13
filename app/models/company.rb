class Company < ApplicationRecord
  before_save :set_converted_name

  has_many :jobs

  private

  def set_converted_name
    converted_name = convert_attribute(name)
  end
end
