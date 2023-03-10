# frozen_string_literal: true

class AddTweetsCountToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :tweets_count, :integer, default: 0
  end
end
