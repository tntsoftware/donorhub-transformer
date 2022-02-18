# frozen_string_literal: true

ActiveAdmin.register Donation do
  belongs_to :organization, finder: :find_by_slug!
  navigation_menu :organization
  filter :designation_account,
         collection: lambda {
                       Pundit.policy_scope(current_user, current_organization.designation_accounts)
                     }
  filter :donor_account,
         collection: -> { Pundit.policy_scope(current_user, current_organization.donor_accounts) }

  filter :created_at
  permit_params :designation_account_id, :donor_account_id, :amount, :currency, :created_at

  index do
    id_column
    column :designation_account
    column :donor_account
    column(:amount) { |donation| number_to_currency(donation.amount, unit: "#{donation.currency} ") }
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :designation_account
      f.input :donor_account
      f.input :amount
      f.input :currency
      f.input :created_at, as: :datepicker
    end
    f.actions
  end
end
