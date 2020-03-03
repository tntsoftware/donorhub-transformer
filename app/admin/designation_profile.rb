# frozen_string_literal: true

ActiveAdmin.register DesignationProfile do
  permit_params :designation_account_id, :member_id

  index do
    selectable_column
    id_column
    column :designation_account
    column :member
    column :created_at
    actions
  end

  filter :designation_account, collection: -> { current_user.organization.designation_accounts.order(:name) }
  filter :member, collection: -> { current_user.organization.members.order(:name) }
  filter :created_at

  form do |f|
    f.inputs 'Designation Account Details' do
      f.input :designation_account,
              collection: -> { current_user.organization.designation_accounts.order(:name).active }
      f.input :member
    end
    f.actions
  end

  controller do
    def scoped_collection
      end_of_association_chain.joins(:designation_account)
                              .where(designation_accounts: { organization: current_organization })
    end
  end
end
