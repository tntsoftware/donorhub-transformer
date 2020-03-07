# frozen_string_literal: true

class AddRemoteUpdatedAt < ActiveRecord::Migration[6.0]
  def change
    add_column :donor_accounts, :remote_updated_at, :timestamp
    add_column :donor_accounts, :code, :string
    add_column :designation_accounts, :remote_updated_at, :timestamp
    add_column :donations, :remote_updated_at, :timestamp
  end
end
