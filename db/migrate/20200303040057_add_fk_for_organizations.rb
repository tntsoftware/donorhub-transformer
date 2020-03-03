# frozen_string_literal: true

class AddFkForOrganizations < ActiveRecord::Migration[6.0]
  class Organization < ApplicationRecord; end
  class DesignationAccount < ApplicationRecord
    belongs_to :organization
  end
  class DonorAccount < ApplicationRecord
    belongs_to :organization
  end
  class Member < ApplicationRecord
    belongs_to :organization
  end
  class User < ApplicationRecord
    belongs_to :organization
  end

  def up
    organization_id = Organization.first.id unless Rails.env.test?

    add_column :designation_accounts, :organization_id, :uuid
    DesignationAccount.update_all(organization_id: organization_id) unless Rails.env.test?
    add_foreign_key :designation_accounts, :organizations, on_delete: :cascade
    change_column :designation_accounts, :organization_id, :uuid, null: false

    add_column :donor_accounts, :organization_id, :uuid
    DonorAccount.update_all(organization_id: organization_id) unless Rails.env.test?
    add_foreign_key :donor_accounts, :organizations, on_delete: :cascade
    change_column :donor_accounts, :organization_id, :uuid, null: false

    add_column :members, :organization_id, :uuid
    Member.update_all(organization_id: organization_id) unless Rails.env.test?
    add_foreign_key :members, :organizations, on_delete: :cascade
    change_column :members, :organization_id, :uuid, null: false

    add_column :users, :organization_id, :uuid
    User.update_all(organization_id: organization_id) unless Rails.env.test?
    add_foreign_key :users, :organizations, on_delete: :cascade
    change_column :users, :organization_id, :uuid, null: false
  end

  def down
    remove_column :designation_accounts, :organization_id
    remove_column :donor_accounts, :organization_id
    remove_column :members, :organization_id
    remove_column :users, :organization_id
  end
end
