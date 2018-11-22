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

ActiveRecord::Schema.define(version: 20140928174302) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "item_counts", force: :cascade do |t|
    t.integer  "num"
    t.date     "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_item_counts_on_date", using: :btree
  end

  create_table "items", force: :cascade do |t|
    t.text     "title"
    t.text     "artist"
    t.integer  "year"
    t.text     "label"
    t.text     "format"
    t.text     "condition"
    t.text     "price_paid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "color"
    t.boolean  "deleted",     default: false
    t.text     "discogs_url"
    t.text     "notes"
    t.index "to_tsvector('english'::regconfig, artist)", name: "items_to_tsvector_idx1", using: :gin
    t.index "to_tsvector('english'::regconfig, color)", name: "items_to_tsvector_idx5", using: :gin
    t.index "to_tsvector('english'::regconfig, condition)", name: "items_to_tsvector_idx4", using: :gin
    t.index "to_tsvector('english'::regconfig, format)", name: "items_to_tsvector_idx3", using: :gin
    t.index "to_tsvector('english'::regconfig, label)", name: "items_to_tsvector_idx2", using: :gin
    t.index "to_tsvector('english'::regconfig, notes)", name: "items_to_tsvector_idx6", using: :gin
    t.index "to_tsvector('english'::regconfig, title)", name: "items_to_tsvector_idx", using: :gin
    t.index ["artist"], name: "index_items_on_artist", using: :btree
    t.index ["color"], name: "index_items_on_color", using: :btree
    t.index ["condition"], name: "index_items_on_condition", using: :btree
    t.index ["created_at"], name: "index_items_on_created_at", using: :btree
    t.index ["format"], name: "index_items_on_format", using: :btree
    t.index ["label"], name: "index_items_on_label", using: :btree
    t.index ["price_paid"], name: "index_items_on_price_paid", using: :btree
    t.index ["title"], name: "index_items_on_title", using: :btree
    t.index ["updated_at"], name: "index_items_on_updated_at", using: :btree
    t.index ["year"], name: "index_items_on_year", using: :btree
  end

  create_table "rails_admin_histories", force: :cascade do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      limit: 2
    t.bigint   "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["item", "table", "month", "year"], name: "index_rails_admin_histories", using: :btree
  end

  create_table "users", force: :cascade do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                  default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
