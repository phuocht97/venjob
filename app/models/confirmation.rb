class Confirmation < ApplicationRecord
  before_save { self.email = email.downcase }
  before_save :create_confirm_token
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 200 },
    format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  def self.confirm_token
    SecureRandom.urlsafe_base64
  end

  def self.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def token_expired?
    updated_at <= 24.hours.ago
  end

  private

  def create_confirm_token
    self.confirm_token = Confirmation.digest(Confirmation.confirm_token)
  end
end
