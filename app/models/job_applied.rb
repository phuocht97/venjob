require 'csv'
class JobApplied < ApplicationRecord
  before_save { self.email = email.downcase }
  mount_uploader :cv_user, UserCvUploader

  belongs_to :user
  belongs_to :job

  LIMIT_PAGE = 20

  validates :name,  presence: true, length: { maximum: 200 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 200 }, format: { with: VALID_EMAIL_REGEX }
  validates :cv_user, presence: true

  def self.to_csv
    attributes = %w{title name cv_user email updated_at}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |info_application|
        info_applied = info_application.attributes.values_at(*attributes)
        info_applied[0] = info_application.job.title
        csv << info_applied
      end
    end
  end
end
