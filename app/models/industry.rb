class Industry < ApplicationRecord
  has_many :industry_jobs
  has_many :jobs, through: :industry_jobs

  scope :top_industry, -> { joins(:jobs).group(:industry_id).order('count(job_id) DESC').limit(9) }
  scope :all_industry, -> { joins(:jobs).group(:industry_id).order('count(job_id) DESC') }

  def convert_name
    name.mb_chars.normalize(:kd).gsub(/[Đđ]/, 'd').gsub(/[^\x00-\x7F]/,'').gsub(/[\W+0-9]/,' ').downcase.to_s.split(' ').join('-')
  end
end
