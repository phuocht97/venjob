module Convert
  def self.to_convert(str)
    str.mb_chars.normalize(:kd).gsub(/[Đđ]/, 'd').gsub(/[^\x00-\x7F]/,'').gsub(/[\W+]/,' ').downcase.to_s.split(' ').join('-')
  end

  def self.to_convert_name(name)
    name.mb_chars.normalize(:kd).gsub(/[Đđ]/, 'd').gsub(/[^\x00-\x7F]/,'').gsub(/[\W+0-9]/,' ').downcase.to_s.split(' ').join('-')
  end
end
