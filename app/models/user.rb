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

  validates :name,  presence: true, length: { maximum: 200 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 200 },
    format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  PASSWORD_FORMAT = /\A(?=.{8,})(?=.*\d)(?=.*[a-z])(?=.*[A-Z])/x
  validates :password, format: { with: PASSWORD_FORMAT, message: "is too short or not strength" }

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def token_expired?
    updated_at <= 24.hours.ago
  end

  private

  def create_remember_token
    self.remember_token = User.digest(User.new_remember_token)
  end
end
