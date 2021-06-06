# frozen_string_literal: true

class CreateDonorAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :donor_accounts, id: :uuid do |t|
      t.string :name
      t.string :remote_id, unique: true

      t.timestamps
    end
  end
end
