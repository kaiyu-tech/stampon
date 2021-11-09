# frozen_string_literal: true

class CreateMarks < ActiveRecord::Migration[6.1]
  def change
    create_table :marks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :message, null: false, foreign_key: true
      t.string :title, null: false, default: ''
      t.text :note, null: false, default: ''
      t.boolean :read, null: false, default: false

      t.timestamps
    end
    add_index :marks, %i[user_id message_id], unique: true
  end
end
