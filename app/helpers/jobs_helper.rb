module JobsHelper
  def job_description(description)
    strip_tags(description).truncate_words(30)
  end
end
