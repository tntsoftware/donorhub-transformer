# frozen_string_literal: true

ActiveAdmin.register DesignationProfile do
  belongs_to :organization, finder: :find_by_slug!
  navigation_menu :organization
  permit_params :designation_account_id, :member_id

  index do
    selectable_column
    id_column
    column :designation_account
    column :member
    column :created_at
    actions
  end

  filter :designation_account
  filter :member
  filter :created_at

  form do |f|
    f.inputs 'Designation Account Details' do
      f.input :designation_account, collection: DesignationAccount.active
      f.input :member
    end
    f.actions
  end
end
