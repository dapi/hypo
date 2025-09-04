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

ActiveRecord::Schema[8.0].define(version: 2025_09_04_103731) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "pg_catalog.plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "subdomain", null: false
    t.bigint "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "nodes_updated_at", precision: nil
    t.string "key", null: false
    t.index ["key"], name: "index_accounts_on_key", unique: true
    t.index ["owner_id"], name: "index_accounts_on_owner_id"
    t.index ["subdomain"], name: "index_accounts_on_subdomain", unique: true
  end

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

  create_table "blockchains", force: :cascade do |t|
    t.integer "chain_id"
    t.string "key"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chats", force: :cascade do |t|
    t.string "model_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "extensions", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_extensions_on_name", unique: true
  end

  create_table "hypotheses", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.text "draft"
    t.text "formulated"
    t.text "actions"
    t.text "data"
    t.text "insights"
    t.text "comments"
    t.integer "beilef_in_success"
    t.integer "simplicity"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "how"
    t.text "description"
    t.index ["project_id"], name: "index_hypotheses_on_project_id"
  end

  create_table "image_tags", force: :cascade do |t|
    t.string "tag", null: false
    t.string "repository", null: false
    t.string "description"
    t.boolean "is_available", default: true, null: false
    t.boolean "is_current", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["is_available", "tag"], name: "index_image_tags_on_is_available_and_tag"
    t.index ["is_current"], name: "index_image_tags_on_is_current"
    t.index ["tag"], name: "index_image_tags_on_tag", unique: true
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_memberships_on_account_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "chat_id", null: false
    t.string "role"
    t.text "content"
    t.string "model_id"
    t.integer "input_tokens"
    t.integer "output_tokens"
    t.bigint "tool_call_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_messages_on_chat_id"
    t.index ["tool_call_id"], name: "index_messages_on_tool_call_id"
  end

  create_table "nodes", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "key", null: false
    t.boolean "no_mining", default: false, null: false
    t.integer "block_time", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "state", default: "initiated", null: false
    t.citext "title", null: false
    t.integer "chain_id", default: 56, null: false
    t.string "last_node_job_error_message"
    t.integer "base_fee", default: 0
    t.string "mnemonic", default: "cash boat total sign print jaguar soup dutch gate universe expect tooth"
    t.integer "accounts", default: 3
    t.integer "transaction_block_keeper", default: 64
    t.bigint "image_tag_id", null: false
    t.index ["account_id", "created_at"], name: "index_nodes_on_account_id_and_created_at"
    t.index ["account_id", "title"], name: "index_nodes_on_account_id_and_title", unique: true
    t.index ["account_id"], name: "index_nodes_on_account_id"
    t.index ["image_tag_id"], name: "index_nodes_on_image_tag_id"
    t.index ["key"], name: "index_nodes_on_key", unique: true
  end

  create_table "project_api_keys", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "creator_id"
    t.string "secret_key", null: false
    t.string "access_key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_key"], name: "index_project_api_keys_on_access_key", unique: true
    t.index ["account_id"], name: "index_project_api_keys_on_account_id"
    t.index ["creator_id"], name: "index_project_api_keys_on_creator_id"
  end

  create_table "project_extensions", force: :cascade do |t|
    t.bigint "blockchain_id", null: false
    t.bigint "account_id", null: false
    t.string "title", null: false
    t.string "summary"
    t.string "tag"
    t.jsonb "params", default: {}, null: false
    t.string "extra_dataset_paths", default: [], null: false, array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "extension_id", null: false
    t.index ["account_id"], name: "index_project_extensions_on_account_id"
    t.index ["blockchain_id"], name: "index_project_extensions_on_blockchain_id"
    t.index ["extension_id"], name: "index_project_extensions_on_extension_id"
  end

  create_table "projects", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "instruction"
    t.string "about"
    t.index ["account_id"], name: "index_projects_on_account_id"
  end

  create_table "services", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "name", null: false
    t.bigint "blockchain_id", null: false
    t.string "extra_dataset_paths", default: [], null: false, array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_services_on_account_id"
    t.index ["blockchain_id"], name: "index_services_on_blockchain_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "telegram_users", id: :string, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.string "photo_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tool_calls", force: :cascade do |t|
    t.bigint "message_id", null: false
    t.string "tool_call_id", null: false
    t.string "name", null: false
    t.jsonb "arguments", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_tool_calls_on_message_id"
    t.index ["tool_call_id"], name: "index_tool_calls_on_tool_call_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.datetime "last_login_at"
    t.datetime "last_logout_at"
    t.datetime "last_activity_at"
    t.string "last_login_from_ip_address"
    t.bigint "telegram_user_id"
    t.string "role", default: "user", null: false
    t.string "api_key", null: false
    t.string "locale", default: "en", null: false
    t.datetime "read_guide_at", precision: nil
    t.index ["api_key"], name: "index_users_on_api_key", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["last_logout_at", "last_activity_at"], name: "index_users_on_last_logout_at_and_last_activity_at"
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
    t.index ["telegram_user_id"], name: "index_users_on_telegram_user_id"
  end

  add_foreign_key "accounts", "users", column: "owner_id"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "hypotheses", "projects"
  add_foreign_key "memberships", "accounts"
  add_foreign_key "memberships", "users"
  add_foreign_key "messages", "chats"
  add_foreign_key "nodes", "accounts"
  add_foreign_key "nodes", "image_tags"
  add_foreign_key "project_api_keys", "accounts"
  add_foreign_key "project_api_keys", "users", column: "creator_id"
  add_foreign_key "projects", "accounts"
  add_foreign_key "services", "accounts"
  add_foreign_key "tool_calls", "messages"
end
