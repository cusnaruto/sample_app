class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: [500, 500]
  end

  validates :content, presence: true, length: { maximum: Settings.micropost.content_max_length }
  validates :image, content_type: {in: %w[image/jpeg image/gif image/png],
                                    message: I18n.t("microposts.image.invalid_type")},
                    size: { less_than: Settings.micropost.image_max_size,
                            message: I18n.t("microposts.image.too_large") }
  scope :recent_posts, -> {order created_at: :desc}
  scope :relate_post, ->(user_ids) { where user_id: user_ids }
end
