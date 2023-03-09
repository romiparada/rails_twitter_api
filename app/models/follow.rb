# frozen_string_literal: true

class Follow < ApplicationRecord
  belongs_to :follower, class_name: 'User', counter_cache: :followings_count, inverse_of: :followings
  belongs_to :following, class_name: 'User', counter_cache: :followers_count, inverse_of: :followers

  validates :follower_id, uniqueness: { scope: :following_id }

  validate :follows_himself

  private

  def follows_himself
    return unless follower && following && follower_id == following_id

    errors.add(:follow, "can't follow himself")
  end
end
