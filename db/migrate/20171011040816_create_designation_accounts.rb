# frozen_string_literal: true

class CreateDesignationAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :designation_accounts, id: :uuid do |t|
      t.belongs_to :organization, foreign_key: { on_delete: :cascade }, type: :uuid, null: false
      t.string :name
      t.string :remote_id, unique: true
      t.boolean :active, default: false

      t.timestamps
    end
  end
end
