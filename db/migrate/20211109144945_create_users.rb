# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.bigint :discord_id, null: false
      t.string :name, null: false
      t.string :discriminator, null: false
      t.string :display_name, null: false
      t.string :avatar, null: false
      t.boolean :admin, null: false, default: false
      t.boolean :in_use, null: false, default: false
      t.timestamp :expires_at, null: true, default: nil

      t.timestamps
    end
    add_index :users, :discord_id, unique: true
  end
end
