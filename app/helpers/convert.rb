module ConvertsHelper
  def to_convert(str)
    str.mb_chars.normalize(:kd).gsub(/[Đđ]/, 'd').gsub(/[^\x00-\x7F]/,'').gsub(/[\W+]/,' ').downcase.to_s.split(' ').join('-')
  end
end
