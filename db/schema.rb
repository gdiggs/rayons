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

ActiveRecord::Schema[7.1].define(version: 2023_11_04_143518) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "vector"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "api_tokens", force: :cascade do |t|
    t.string "name"
    t.string "token"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_api_tokens_on_token"
  end

  create_table "item_counts", id: :serial, force: :cascade do |t|
    t.integer "num"
    t.date "date"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["date"], name: "index_item_counts_on_date"
  end

  create_table "items", id: :serial, force: :cascade do |t|
    t.text "title"
    t.text "artist"
    t.integer "year"
    t.text "label"
    t.text "format"
    t.text "condition"
    t.text "price_paid"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "color"
    t.boolean "deleted", default: false
    t.text "discogs_url"
    t.text "notes"
    t.text "genres", default: [], array: true
    t.text "styles", default: [], array: true
    t.vector "embedding", limit: 100
    t.index "to_tsvector('english'::regconfig, artist)", name: "items_to_tsvector_idx1", using: :gin
    t.index "to_tsvector('english'::regconfig, color)", name: "items_to_tsvector_idx5", using: :gin
    t.index "to_tsvector('english'::regconfig, condition)", name: "items_to_tsvector_idx4", using: :gin
    t.index "to_tsvector('english'::regconfig, format)", name: "items_to_tsvector_idx3", using: :gin
    t.index "to_tsvector('english'::regconfig, label)", name: "items_to_tsvector_idx2", using: :gin
    t.index "to_tsvector('english'::regconfig, notes)", name: "items_to_tsvector_idx6", using: :gin
    t.index "to_tsvector('english'::regconfig, title)", name: "items_to_tsvector_idx", using: :gin
    t.index ["artist"], name: "index_items_on_artist"
    t.index ["color"], name: "index_items_on_color"
    t.index ["condition"], name: "index_items_on_condition"
    t.index ["created_at"], name: "index_items_on_created_at"
    t.index ["embedding"], name: "index_items_on_embedding", opclass: :vector_cosine_ops, using: :hnsw
    t.index ["format"], name: "index_items_on_format"
    t.index ["label"], name: "index_items_on_label"
    t.index ["price_paid"], name: "index_items_on_price_paid"
    t.index ["title"], name: "index_items_on_title"
    t.index ["updated_at"], name: "index_items_on_updated_at"
    t.index ["year"], name: "index_items_on_year"
  end

  create_table "rails_admin_histories", id: :serial, force: :cascade do |t|
    t.text "message"
    t.string "username", limit: 255
    t.integer "item"
    t.string "table", limit: 255
    t.integer "month", limit: 2
    t.bigint "year"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["item", "table", "month", "year"], name: "index_rails_admin_histories"
  end

  create_table "tracks", force: :cascade do |t|
    t.string "name"
    t.string "number"
    t.string "artist"
    t.string "duration"
    t.bigint "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tracks"
    t.boolean "deleted"
    t.index ["item_id"], name: "index_tracks_on_item_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "tracks", "items"
end
