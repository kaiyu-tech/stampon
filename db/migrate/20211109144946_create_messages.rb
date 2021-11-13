# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.bigint :channel_id, null: false
      t.bigint :content_id, null: false
      t.text :content, null: false
      t.timestamp :wrote_at, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :messages, %i[channel_id content_id], unique: true
  end
end
