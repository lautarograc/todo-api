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

ActiveRecord::Schema[8.1].define(version: 2024_11_18_045119) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "notifications", force: :cascade do |t|
    t.bigint "todo_id", null: false
    t.string "notification_type", null: false
    t.text "content"
    t.datetime "sent_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["todo_id"], name: "index_notifications_on_todo_id"
  end

  create_table "todos", force: :cascade do |t|
    t.string "name", limit: 120, null: false
    t.text "description"
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "lft"
    t.integer "rgt"
    t.integer "parent_id"
    t.integer "depth", default: 0
    t.integer "children_count", default: 0
    t.datetime "due_date"
    t.integer "priority", default: 0
    t.integer "status", default: 0
    t.index ["due_date"], name: "index_todos_on_due_date"
    t.index ["parent_id"], name: "index_todos_on_parent_id"
    t.index ["priority"], name: "index_todos_on_priority"
    t.index ["rgt"], name: "index_todos_on_rgt"
    t.index ["status"], name: "index_todos_on_status"
    t.index ["user_id"], name: "index_todos_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "notifications", "todos"
  add_foreign_key "todos", "users"
end
