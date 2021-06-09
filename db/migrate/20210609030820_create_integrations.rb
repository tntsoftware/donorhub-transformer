class CreateIntegrations < ActiveRecord::Migration[6.1]
  def change
    create_table :integrations, id: :uuid do |t|
      t.belongs_to :organization, foreign_key: { on_delete: :cascade }, type: :uuid, null: false
      t.jsonb :payload, null: false, default: '{}'
      t.string :type

      t.timestamps
    end

    add_index :integrations, :payload, using: :gin
  end
end
