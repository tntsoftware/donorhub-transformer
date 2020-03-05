# frozen_string_literal: true

class AddRemoteIdToIntegrations < ActiveRecord::Migration[6.0]
  def change
    add_column :integrations, :remote_id, :string, null: false
  end
end
