# frozen_string_literal: true

class Like < ApplicationRecord
  belongs_to :user
  belongs_to :tweet, counter_cache: true

  validate :likes_own_tweet

  private

  def likes_own_tweet
    return unless tweet && user && user_id == tweet.user_id

    errors.add(:user, "can't like his own tweet")
  end
end
