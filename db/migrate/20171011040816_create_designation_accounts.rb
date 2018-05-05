class CreateDesignationAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :designation_accounts, id: :uuid do |t|
      t.string :name
      t.string :remote_id, unique: true
      t.boolean :active, default: false

      t.timestamps
    end
  end
end
