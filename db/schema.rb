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

ActiveRecord::Schema.define(version: 20_210_618_235_504) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'pgcrypto'
  enable_extension 'plpgsql'

  create_table 'designation_accounts', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.uuid 'organization_id', null: false
    t.string 'name'
    t.string 'remote_id'
    t.boolean 'active', default: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.decimal 'balance', default: '0.0'
    t.index ['organization_id'], name: 'index_designation_accounts_on_organization_id'
  end

  create_table 'designation_profiles', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.uuid 'organization_id', null: false
    t.uuid 'designation_account_id', null: false
    t.uuid 'member_id', null: false
    t.string 'remote_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[designation_account_id member_id], name: 'idx_uniq_da_id_and_member_id', unique: true
    t.index ['designation_account_id'], name: 'index_designation_profiles_on_designation_account_id'
    t.index ['member_id'], name: 'index_designation_profiles_on_member_id'
    t.index ['organization_id'], name: 'index_designation_profiles_on_organization_id'
  end

  create_table 'donations', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.uuid 'organization_id', null: false
    t.uuid 'designation_account_id', null: false
    t.uuid 'donor_account_id', null: false
    t.string 'remote_id'
    t.decimal 'amount'
    t.string 'currency'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['designation_account_id'], name: 'index_donations_on_designation_account_id'
    t.index ['donor_account_id'], name: 'index_donations_on_donor_account_id'
    t.index ['organization_id'], name: 'index_donations_on_organization_id'
  end

  create_table 'donor_accounts', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.uuid 'organization_id', null: false
    t.string 'name'
    t.string 'remote_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['organization_id'], name: 'index_donor_accounts_on_organization_id'
  end

  create_table 'integrations', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.uuid 'organization_id', null: false
    t.string 'remote_id', null: false
    t.jsonb 'payload', default: '{}', null: false
    t.string 'type'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['organization_id'], name: 'index_integrations_on_organization_id'
    t.index ['payload'], name: 'index_integrations_on_payload', using: :gin
    t.index %w[remote_id organization_id], name: 'index_integrations_on_remote_id_and_organization_id', unique: true
  end

  create_table 'members', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.uuid 'organization_id', null: false
    t.string 'name', null: false
    t.string 'email', null: false
    t.string 'access_token', null: false
    t.string 'remote_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[email access_token], name: 'index_members_on_email_and_access_token', unique: true
    t.index ['organization_id'], name: 'index_members_on_organization_id'
  end

  create_table 'organizations', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.string 'code', null: false
    t.string 'name', null: false
    t.string 'abbreviation'
    t.string 'account_help_url'
    t.string 'request_profile_url'
    t.string 'help_url'
    t.string 'help_description'
    t.string 'currency_code'
    t.string 'slug', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['slug'], name: 'index_organizations_on_slug', unique: true
  end

  create_table 'users', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.uuid 'organization_id', null: false
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.datetime 'remember_created_at'
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.integer 'sign_in_count', default: 0, null: false
    t.datetime 'current_sign_in_at'
    t.datetime 'last_sign_in_at'
    t.inet 'current_sign_in_ip'
    t.inet 'last_sign_in_ip'
    t.index %w[email organization_id], name: 'index_users_on_email_and_organization_id', unique: true
    t.index ['organization_id'], name: 'index_users_on_organization_id'
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end

  add_foreign_key 'designation_accounts', 'organizations', on_delete: :cascade
  add_foreign_key 'designation_profiles', 'designation_accounts', on_delete: :cascade
  add_foreign_key 'designation_profiles', 'members', on_delete: :cascade
  add_foreign_key 'designation_profiles', 'organizations', on_delete: :cascade
  add_foreign_key 'donations', 'designation_accounts', on_delete: :cascade
  add_foreign_key 'donations', 'donor_accounts', on_delete: :cascade
  add_foreign_key 'donations', 'organizations', on_delete: :cascade
  add_foreign_key 'donor_accounts', 'organizations', on_delete: :cascade
  add_foreign_key 'integrations', 'organizations', on_delete: :cascade
  add_foreign_key 'members', 'organizations', on_delete: :cascade
  add_foreign_key 'users', 'organizations', on_delete: :cascade
end
