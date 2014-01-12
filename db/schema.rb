# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140112194406) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "items", force: true do |t|
    t.text     "title"
    t.text     "artist"
    t.integer  "year"
    t.text     "label"
    t.text     "format"
    t.text     "condition"
    t.text     "price_paid"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.text     "color"
    t.boolean  "deleted",     default: false
    t.text     "discogs_url"
  end

  add_index "items", ["artist"], name: "index_items_on_artist", using: :btree
  add_index "items", ["color"], name: "index_items_on_color", using: :btree
  add_index "items", ["condition"], name: "index_items_on_condition", using: :btree
  add_index "items", ["created_at"], name: "index_items_on_created_at", using: :btree
  add_index "items", ["format"], name: "index_items_on_format", using: :btree
  add_index "items", ["label"], name: "index_items_on_label", using: :btree
  add_index "items", ["price_paid"], name: "index_items_on_price_paid", using: :btree
  add_index "items", ["title"], name: "index_items_on_title", using: :btree
  add_index "items", ["updated_at"], name: "index_items_on_updated_at", using: :btree
  add_index "items", ["year"], name: "index_items_on_year", using: :btree

  create_table "rails_admin_histories", force: true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      limit: 2
    t.integer  "year",       limit: 8
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], name: "index_rails_admin_histories", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "admin",                  default: false, null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
