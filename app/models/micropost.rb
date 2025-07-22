class Micropost < ApplicationRecord
  scope :most_recent, ->{order(created_at: :desc)}
end
