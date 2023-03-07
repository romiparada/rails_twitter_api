# frozen_string_literal: true

class CreateFollows < ActiveRecord::Migration[7.0]
  def change
    create_table :follows do |t|
      t.belongs_to :follower, null: false, foreign_key: { to_table: :users }
      t.belongs_to :followed, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :follows, %i[follower_id followed_id], unique: true
  end
end
