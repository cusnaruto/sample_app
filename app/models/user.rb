class User < ApplicationRecord
  PASSWORD_MAXIMUM_LENGTH = 255
  AGE_MAXIMUM = 100.years

  attr_accessor :remember_token

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

  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost:
  end

  # Generate a random token
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated? remember_token
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

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
