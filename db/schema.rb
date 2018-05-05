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

ActiveRecord::Schema.define(version: 20171011214054) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pgcrypto"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "designation_accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "status"
    t.string "account_type"
    t.string "tax_type"
    t.string "description"
    t.string "klass"
    t.boolean "enable_payments_to_account"
    t.boolean "show_in_expense_claims"
    t.string "reporting_code"
    t.string "reporting_code_name"
    t.boolean "sync_donations", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "designation_profile_permissions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "designation_profile_id"
    t.uuid "designation_account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["designation_account_id"], name: "index_designation_profile_permissions_on_designation_account_id"
    t.index ["designation_profile_id", "designation_account_id"], name: "designation_profile_permissions_uniqueness_index", unique: true
    t.index ["designation_profile_id"], name: "index_designation_profile_permissions_on_designation_profile_id"
  end

  create_table "designation_profiles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "donations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "designation_account_id"
    t.uuid "donor_account_id"
    t.string "description"
    t.decimal "unit_amount"
    t.string "tax_type"
    t.decimal "tax_amount"
    t.decimal "line_amount"
    t.decimal "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["designation_account_id"], name: "index_donations_on_designation_account_id"
    t.index ["donor_account_id"], name: "index_donations_on_donor_account_id"
  end

  create_table "donor_accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.boolean "is_supplier"
    t.boolean "is_customer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_permissions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.uuid "designation_profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["designation_profile_id", "user_id"], name: "user_permissions_uniqueness_index", unique: true
    t.index ["designation_profile_id"], name: "index_user_permissions_on_designation_profile_id"
    t.index ["user_id"], name: "index_user_permissions_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "role"
    t.string "authentication_token", limit: 30
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "designation_profile_permissions", "designation_accounts"
  add_foreign_key "designation_profile_permissions", "designation_profiles"
  add_foreign_key "donations", "designation_accounts"
  add_foreign_key "donations", "donor_accounts"
  add_foreign_key "user_permissions", "designation_profiles"
  add_foreign_key "user_permissions", "users"
end
