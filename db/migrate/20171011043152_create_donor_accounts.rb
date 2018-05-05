class CreateDonorAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :donor_accounts, id: :uuid do |t|
      t.string :name
      t.boolean :is_supplier
      t.boolean :is_customer

      t.timestamps
    end
  end
end
