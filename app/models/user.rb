class User < ApplicationRecord
  PASSWORD_MAXIMUM_LENGTH = 255
  AGE_MAXIMUM = 100.years

  enum gender: {male: 0, female: 1, other: 2}

  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true
  validates :email, presence: true, length: {maximum: PASSWORD_MAXIMUM_LENGTH},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
  validates :dob, presence: true
  validates :gender, presence: true

  validate :dob_valid

  private

  def dob_valid
    return if dob.blank?

    if dob > Time.zone.today
      errors.add(:dob, :future_date)
    elsif dob < AGE_MAXIMUM.ago.to_date
      errors.add(:dob, :too_old)
    end
  end
end
