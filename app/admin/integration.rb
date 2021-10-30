# frozen_string_literal: true

ActiveAdmin.register Integration do
  belongs_to :organization, finder: :find_by_slug!
  navigation_menu :organization

  action_item :view, only: :index do
    link_to 'Add Xero Integration', "/auth/xero_oauth2?origin=#{organization.slug}", method: :post
  end

  index do
    id_column
    column :type
    column :created_at
    actions
  end
end
