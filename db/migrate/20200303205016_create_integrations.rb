# frozen_string_literal: true

class CreateIntegrations < ActiveRecord::Migration[6.0]
  def change
    create_table :integrations, id: :uuid do |t|
      t.belongs_to :organization, foreign_key: { on_delete: :cascade }, type: :uuid, null: false
      t.string :encrypted_access_token
      t.string :encrypted_access_token_iv
      t.string :encrypted_refresh_token
      t.string :encrypted_refresh_token_iv
      t.string :type, null: false
      t.text :metadata
      t.timestamp :expires_at
      t.timestamp :last_download_attempted_at
      t.timestamp :last_downloaded_at

      t.timestamps
    end

    add_index :integrations, :encrypted_access_token_iv, unique: true
    add_index :integrations, :encrypted_refresh_token_iv, unique: true
  end
end
