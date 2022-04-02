# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users, id: :uuid do |t|
      t.belongs_to :organization, foreign_key: {on_delete: :cascade}, type: :uuid, null: false
      ## Database authenticatable
      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Rememberable
      t.datetime :remember_created_at

      t.string :name

      t.timestamps null: false
    end

    add_index :users, %i[email organization_id], unique: true
  end
end
