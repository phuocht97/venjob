class JobApplied < ApplicationRecord
  before_save { self.email = email.downcase }
  mount_uploader :cv_user, UserCvUploader

  belongs_to :user
  belongs_to :job

  scope :email, ->(email) { where(email: email) if email.present? }
  scope :city, ->(city_id) { where(cities: {id: city_id}) if city_id.present? }
  scope :industry, ->(industry_id) { where(industries: {id: industry_id}) if industry_id.present?}

  scope :datetime, ->(from_datetime, to_datetime) {
                        where("job_applieds.updated_at BETWEEN ? AND ?", from_datetime, to_datetime)
                      }

  LIMIT_PAGE = 20
  CSV_ATTRIBUTES = %w(title name cv_user email updated_at).freeze

  validates :name,  presence: true, length: { maximum: 200 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 200 }, format: { with: VALID_EMAIL_REGEX }
  validates :cv_user, presence: true
end
