module JobsHelper
  def job_description(description)
    strip_tags(description).truncate_words(250)
  end
end
