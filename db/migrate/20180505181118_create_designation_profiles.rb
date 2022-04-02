# frozen_string_literal: true

class CreateDesignationProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :designation_profiles, id: :uuid do |t|
      t.belongs_to :organization, foreign_key: {on_delete: :cascade}, type: :uuid, null: false
      t.belongs_to :designation_account, foreign_key: {on_delete: :cascade}, type: :uuid, null: false
      t.belongs_to :member, foreign_key: {on_delete: :cascade}, type: :uuid, null: false
      t.string :remote_id, unique: true

      t.timestamps
    end
  end
end
