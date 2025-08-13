class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: Relationship.name,
            foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
            foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  PASSWORD_MAXIMUM_LENGTH = 255
  AGE_MAXIMUM = 100.years

  attr_accessor :remember_token, :activation_token, :reset_token

  before_save :downcase_email
  before_create :create_activation_digest

  scope :newest_first, ->{order(created_at: :desc)}

  has_secure_password

  USER_PERMIT_PARAMS = %i(name email password password_confirmation dob
gender).freeze
  MICROPOST_PRELOAD = [:user, {image_attachment: :blob}].freeze

  enum gender: {male: 0, female: 1, other: 2}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true
  validates :email, presence: true, length: {maximum: PASSWORD_MAXIMUM_LENGTH},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
  validates :password, presence: true, length:
            {minimum: Settings.digits.digit_6},
            allow_nil: true
  validates :dob, presence: true

  validate :dob_valid

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create(string, cost:)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_column(:remember_digest, User.digest(remember_token))
  end

  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_column(:remember_digest, nil)
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(
      reset_digest: User.digest(reset_token),
      reset_sent_at: Time.zone.now
    )
  end

  def password_reset_expired?
    reset_sent_at < Settings.time.password_reset_expired.hours.ago
  end

  def feed
    Micropost.relate_post(following_ids << id).includes(MICROPOST_PRELOAD)
  end

  def follow other_user
    following << other_user
  end

  def unfollow other_user
    following.delete(other_user)
  end

  def following? other_user
    following.include? other_user
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

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
