# frozen_string_literal: true

class AddLikesCountToTweet < ActiveRecord::Migration[7.0]
  def change
    add_column :tweets, :likes_count, :integer, default: 0
  end
end
