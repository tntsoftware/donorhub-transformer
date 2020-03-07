# frozen_string_literal: true

class AddAuthHashToIntegrations < ActiveRecord::Migration[6.0]
  def change
    add_column :integrations, :auth_hash, :text
  end
end
