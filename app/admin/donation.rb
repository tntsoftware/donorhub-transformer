# frozen_string_literal: true

ActiveAdmin.register Donation do
  belongs_to :organization, finder: :find_by_slug!
  navigation_menu :organization
  filter :designation_account, collection: -> { DesignationAccount.where(active: true) }
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
