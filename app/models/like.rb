# frozen_string_literal: true

class Like < ApplicationRecord
  belongs_to :user
  belongs_to :tweet

  validate :like_own_tweet

  private

  def like_own_tweet
    return unless tweet && user == tweet.user

    errors.add(:user, "can't like his own tweet")
  end
end
