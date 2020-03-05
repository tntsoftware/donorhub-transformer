# frozen_string_literal: true

class AddCodeToDesignationAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :designation_accounts, :code, :string
  end
end
