# frozen_string_literal: true

ActiveAdmin.register Donation do
  filter :designation_account,
         collection: -> { current_user.organization.designation_accounts.where(active: true).order(:name) }
  filter :donor_account,
         collection: -> { current_user.organization.donor_accounts.order(:name) }

  index do
    id_column
    column :designation_account
    column :donor_account
    column(:amount) { |donation| number_to_currency(donation.amount, unit: "#{donation.currency} ") }
    column :created_at
    actions
  end

  controller do
    def scoped_collection
      end_of_association_chain.joins(:designation_account)
                              .includes(:donor_account, :designation_account)
                              .where(designation_accounts: { active: true, organization: current_organization })
    end
  end
end
