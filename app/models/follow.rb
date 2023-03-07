# frozen_string_literal: true

class Follow < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'

  validates :follower_id, uniqueness: { scope: :followed_id }

  validate :follows_himself

  private

  def follows_himself
    return unless follower && followed && follower_id == followed_id

    errors.add(:follow, "can't follow himself")
  end
end
