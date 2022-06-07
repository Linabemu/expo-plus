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

ActiveRecord::Schema[7.0].define(version: 2022_06_07_094820) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
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
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "chatrooms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expos", force: :cascade do |t|
    t.integer "api_records_id"
    t.date "api_updated_at"
    t.string "title"
    t.text "lead_text"
    t.text "description"
    t.string "tags", array: true
    t.string "cover_url"
    t.string "cover_alt"
    t.string "cover_credit"
    t.date "date_start"
    t.date "date_end"
    t.string "occurences", array: true
    t.string "date_description"
    t.string "price_type"
    t.string "price_detail"
    t.string "contact_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "place_id", null: false
    t.index ["place_id"], name: "index_expos_on_place_id"
  end

  create_table "followings", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "receiver_id", null: false
    t.index ["receiver_id"], name: "index_followings_on_receiver_id"
    t.index ["user_id"], name: "index_followings_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id", null: false
    t.bigint "proposal_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["proposal_id"], name: "index_messages_on_proposal_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "participants", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "proposal_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["proposal_id"], name: "index_participants_on_proposal_id"
    t.index ["user_id"], name: "index_participants_on_user_id"
  end

  create_table "places", force: :cascade do |t|
    t.string "address_name"
    t.string "address_street"
    t.string "address_city"
    t.string "address_zipcode"
    t.float "lat"
    t.float "lon"
    t.string "access_link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "proposals", force: :cascade do |t|
    t.boolean "confirmed"
    t.integer "max_participants"
    t.bigint "user_id", null: false
    t.bigint "expo_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.date "date_proposale"
    t.index ["expo_id"], name: "index_proposals_on_expo_id"
    t.index ["user_id"], name: "index_proposals_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "rating"
    t.text "comment"
    t.bigint "user_id", null: false
    t.bigint "expo_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expo_id"], name: "index_reviews_on_expo_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.text "description"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wishes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "expo_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expo_id"], name: "index_wishes_on_expo_id"
    t.index ["user_id"], name: "index_wishes_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "expos", "places"
  add_foreign_key "followings", "users"
  add_foreign_key "followings", "users", column: "receiver_id"
  add_foreign_key "messages", "proposals"
  add_foreign_key "messages", "users"
  add_foreign_key "participants", "proposals"
  add_foreign_key "participants", "users"
  add_foreign_key "proposals", "expos"
  add_foreign_key "proposals", "users"
  add_foreign_key "reviews", "expos"
  add_foreign_key "reviews", "users"
  add_foreign_key "wishes", "expos"
  add_foreign_key "wishes", "users"
end
