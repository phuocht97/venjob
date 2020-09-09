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
        csv << info_application.job.attributes.values_at(attributes[0])
        csv << attributes[(1..4)].map{ |attr| info_application.send(attr) }
      end
    end
  end
end
