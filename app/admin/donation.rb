ActiveAdmin.register Donation do
  controller do
    def scoped_collection
      end_of_association_chain.joins(:designation_account).where(designation_accounts: { active: true })
    end
  end

  filter :designation_account, collection: DesignationAccount.where(active: true)
  filter :donor_account

  index do
    id_column
    column :designation_account
    column :donor_account
    column(:amount) { |donation| number_to_currency(donation.amount, unit: "#{donation.currency} ") }
    column :created_at
    actions
  end
end
