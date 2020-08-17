class User < ApplicationRecord
  before_save { self.email = email.downcase }
  before_create :create_remember_token
  mount_uploader :cv_user, UserCvUploader

  has_many :favorite_jobs
  has_many :jobs, through: :favorite_jobs
  has_many :job_applieds
  has_many :jobs, through: :job_applieds
  has_many :histories
  has_many :jobs, through: :histories

  has_secure_password

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }

  validates :password, allow_nil: true, length: { minimum: 6, too_short: "is blank or too short" }

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

  def create_remember_token
    self.remember_token = User.digest(User.new_remember_token)
  end
end
