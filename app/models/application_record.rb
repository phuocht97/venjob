class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def convert_attribute
    self.converted_name = normalize_attribute.mb_chars.normalize(:kd).gsub(/[Đđ]/, 'd').gsub(/[^\x00-\x7F]/,'').gsub(/[\W+]/,' ').downcase.to_s.split(' ').join('-')
  end
end
