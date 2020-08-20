class ResetPassword < ApplicationRecord
  before_save :create_remember_token

  has_secure_password

  PASSWORD_FORMAT = /\A(?=.{8,})(?=.*\d)(?=.*[a-z])(?=.*[A-Z])/x
  validates :password, format: { with: PASSWORD_FORMAT, message: "is too short or not strength" }

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

  def create_remember_token
    self.remember_token = User.digest(User.new_remember_token)
  end
end
