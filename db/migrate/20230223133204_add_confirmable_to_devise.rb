# frozen_string_literal: true

class AddConfirmableToDevise < ActiveRecord::Migration[7.0]
  def up
    change_table :users, bulk: true do |t|
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
    end

    add_index :users, :confirmation_token, unique: true

    User.update_all confirmed_at: DateTime.now # rubocop:disable Rails/SkipsModelValidations
  end

  def down
    remove_index :users, :confirmation_token
    remove_columns :users, :confirmation_token, :confirmed_at, :confirmation_sent_at
  end
end
