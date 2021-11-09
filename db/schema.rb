# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_11_09_144948) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "marks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "message_id", null: false
    t.string "title", default: "", null: false
    t.text "note", default: "", null: false
    t.boolean "read", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["message_id"], name: "index_marks_on_message_id"
    t.index ["user_id", "message_id"], name: "index_marks_on_user_id_and_message_id", unique: true
    t.index ["user_id"], name: "index_marks_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "channel_id", null: false
    t.bigint "content_id", null: false
    t.text "content", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["channel_id", "content_id"], name: "index_messages_on_channel_id_and_content_id", unique: true
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.bigint "discord_id", null: false
    t.string "name", null: false
    t.string "discriminator", null: false
    t.string "avatar", null: false
    t.boolean "admin", default: false, null: false
    t.boolean "in_use", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["discord_id"], name: "index_users_on_discord_id", unique: true
  end

  add_foreign_key "marks", "messages"
  add_foreign_key "marks", "users"
  add_foreign_key "messages", "users"
end
