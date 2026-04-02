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

ActiveRecord::Schema[8.0].define(version: 2026_03_31_062756) do
  create_table "ownerships", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "rubygem_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rubygem_id"], name: "index_ownerships_on_rubygem_id"
    t.index ["user_id"], name: "index_ownerships_on_user_id"
  end

  create_table "registry_events", force: :cascade do |t|
    t.string "event_type"
    t.integer "rubygem_id"
    t.integer "actor_id"
    t.text "payload"
    t.string "previous_hash"
    t.string "hash_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rubygems", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "versions", force: :cascade do |t|
    t.string "number"
    t.integer "rubygem_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rubygem_id"], name: "index_versions_on_rubygem_id"
  end

  add_foreign_key "ownerships", "rubygems"
  add_foreign_key "ownerships", "users"
  add_foreign_key "versions", "rubygems"
end
