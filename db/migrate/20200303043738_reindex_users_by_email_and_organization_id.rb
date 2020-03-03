# frozen_string_literal: true

class ReindexUsersByEmailAndOrganizationId < ActiveRecord::Migration[6.0]
  def up
    remove_index :users, :email
    add_index :users, %i[email organization_id], unique: true
  end

  def down
    remove_index :users, %i[email organization_id]
    add_index :users, :email, unique: true
  end
end
