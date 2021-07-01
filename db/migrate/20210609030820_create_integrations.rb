# frozen_string_literal: true

class CreateIntegrations < ActiveRecord::Migration[6.1]
  def change
    create_table :integrations, id: :uuid do |t|
      t.belongs_to :organization, foreign_key: { on_delete: :cascade }, type: :uuid, null: false
      t.string :remote_id, null: false
      t.jsonb :payload, null: false, default: '{}'
      t.timestamp :last_synced_at
      t.string :type

      t.timestamps
    end

    add_index :integrations, :payload, using: :gin
    add_index :integrations, %i[remote_id organization_id], unique: true
  end
end
