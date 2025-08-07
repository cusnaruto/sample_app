class Micropost < ApplicationRecord
  MICROPOST_PERMIT = %i(content image).freeze
  IMAGE_PRELOAD = [{image_attachment: :blob}].freeze
  IMAGE_TYPE = %w(image/jpeg image/gif image/png).freeze

  belongs_to :user
  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: [1024, 1024]
  end

  scope :recent_posts, ->{order created_at: :desc}
  scope :relate_post, ->(user_ids){where user_id: user_ids}

  validates :content, presence: true,
length: {maximum: Settings.micropost.content_max_length}
  validates :image, content_type: {in: IMAGE_TYPE,
                                   message: :invalid_image_format},
                  size: {less_than: Settings.micropost.image_max_size.megabytes,
                         message: :image_too_large}
end
