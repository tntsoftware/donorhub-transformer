class AddValidCredentialsToIntegrations < ActiveRecord::Migration[6.0]
  def change
    add_column :integrations, :valid_credentials, :boolean, default: true
  end
end
