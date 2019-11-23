class AddBalanceToDesignationAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :designation_accounts, :balance, :decimal, default: 0
  end
end
