# frozen_string_literal: true

class AddIndexes < ActiveRecord::Migration[6.0]
  def change
    add_index :designation_accounts, :organization_id
    add_index :designation_accounts, %i[organization_id remote_id]
    add_index :donations, %i[designation_account_id remote_id]
    add_index :donations, %i[donor_account_id remote_id]
    add_index :donor_accounts, :organization_id
    add_index :donor_accounts, %i[organization_id remote_id]
    add_index :members, :organization_id
    add_index :members, %i[organization_id remote_id]
    add_index :designation_profiles, %i[member_id remote_id]
    add_index :designation_profiles, %i[designation_account_id remote_id], name: 'idx_dp_da_r'
    add_index :integrations, %i[organization_id remote_id]
  end
end
