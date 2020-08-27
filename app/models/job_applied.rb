class JobApplied < ApplicationRecord
  before_save { self.email = email.downcase }
  mount_uploader :cv_user, UserCvUploader

  belongs_to :user
  belongs_to :job

  validates :name,  presence: true, length: { maximum: 200 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 200 }, format: { with: VALID_EMAIL_REGEX }
  validates :cv_user, presence: true

end
