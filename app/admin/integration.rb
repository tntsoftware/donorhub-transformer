# frozen_string_literal: true

ActiveAdmin.register Integration do
  belongs_to :organization, finder: :find_by_slug!
  navigation_menu :organization
  actions :index, :show, :destroy

  action_item :view, only: :index do
    link_to 'Add Xero Integration', "/auth/xero_oauth2?origin=#{organization.slug}", method: :post
  end

  filter :type
  filter :last_sync_at
  filter :created_at
  filter :updated_at

  index do
    id_column
    column :type
    column :last_sync_at
    column :created_at
    column :updated_at
    actions
  end
end
