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

ActiveRecord::Schema[7.0].define(version: 2023_11_23_174822) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", null: false
    t.string "type"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_accounts_on_email", unique: true
  end

  create_table "active_sessions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_active_sessions_on_account_id"
  end

  create_table "transactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wallet_transaction_errors", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "wallet_transaction_id", null: false
    t.string "error_type", null: false
    t.text "message", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["wallet_transaction_id"], name: "index_wallet_transaction_errors_on_wallet_transaction_id"
  end

  create_table "wallet_transactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "debit_source_id", null: false
    t.uuid "credit_source_id", null: false
    t.decimal "debit_amount", precision: 25, scale: 5, default: "0.0", null: false
    t.decimal "credit_amount", precision: 25, scale: 5, default: "0.0", null: false
    t.integer "status", default: 0, null: false
    t.string "transferable_type"
    t.uuid "transferable_id"
    t.datetime "processed_on"
    t.datetime "completed_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["credit_source_id"], name: "index_wallet_transactions_on_credit_source_id"
    t.index ["debit_source_id"], name: "index_wallet_transactions_on_debit_source_id"
    t.index ["transferable_type", "transferable_id"], name: "index_wallet_transactions_on_transferable"
  end

  create_table "wallets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.boolean "enabled", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_wallets_on_account_id"
  end

  add_foreign_key "active_sessions", "accounts"
  add_foreign_key "wallet_transaction_errors", "wallet_transactions"
  add_foreign_key "wallet_transactions", "wallets", column: "credit_source_id"
  add_foreign_key "wallet_transactions", "wallets", column: "debit_source_id"
  add_foreign_key "wallets", "accounts"
end
