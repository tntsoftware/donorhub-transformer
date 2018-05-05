ActiveAdmin.register DesignationProfile do
  permit_params :designation_account_id, :member_ids

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
end
