class CreateDesignationAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :designation_accounts, id: :uuid do |t|
      t.string :code
      t.string :name
      t.string :status
      t.string :account_type
      t.string :tax_type
      t.string :description
      t.string :klass
      t.boolean :enable_payments_to_account
      t.boolean :show_in_expense_claims
      t.string :reporting_code
      t.string :reporting_code_name
      t.boolean :sync_donations, default: false

      t.timestamps
    end
  end
end
