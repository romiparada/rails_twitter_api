# frozen_string_literal: true

class Follow < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :following, class_name: 'User'

  validates :follower_id, uniqueness: { scope: :following_id }

  validate :follows_himself

  private

  def follows_himself
    return unless follower && following && follower_id == following_id

    errors.add(:follow, "can't follow himself")
  end
end
