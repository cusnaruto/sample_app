class User < ApplicationRecord
  has_secure_password
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true
  validates :email, presence: true, length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
  validates :dob, presence: true

  validate :dob_valid

  private

  def dob_valid
    return if dob.blank?

    if dob > Time.zone.today
      errors.add(:dob, "can't be in the future")
    elsif dob < 100.years.ago.to_date
      errors.add(:dob, "can't be more than 100 years ago")
    end
  end
end
