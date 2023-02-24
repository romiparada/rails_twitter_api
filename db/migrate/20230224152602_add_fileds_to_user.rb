# frozen_string_literal: true

class AddFiledsToUser < ActiveRecord::Migration[7.0]
  def change
    change_table :users, bulk: true do |t|
      t.string :name
      t.text :bio
      t.string :website
      t.date :birthdate
      t.string :username
    end

    add_index :users, :username, unique: true
  end
end
