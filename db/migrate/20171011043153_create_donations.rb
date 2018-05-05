class CreateDonations < ActiveRecord::Migration[5.1]
  def change
    create_table :donations, id: :uuid do |t|
      t.belongs_to :designation_account, foreign_key: true, type: :uuid
      t.belongs_to :donor_account, foreign_key: true, type: :uuid
      t.string :description
      t.decimal :unit_amount
      t.string :tax_type
      t.decimal :tax_amount
      t.decimal :line_amount
      t.decimal :quantity
      t.timestamps
    end
  end
end
