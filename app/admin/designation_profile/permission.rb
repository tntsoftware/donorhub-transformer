ActiveAdmin.register DesignationProfile::Permission do
  menu label: 'Permissions', parent: 'Designation Profiles'
  permit_params :designation_profile_id, :designation_account_id

  index do
    selectable_column
    id_column
    column :designation_profile
    column :designation_account
    column :created_at
    actions
  end

  filter :designation_profile
  filter :designation_account
  filter :created_at

  form do |f|
    f.inputs 'Designation Profile Permission Details' do
      f.input :designation_profile
      f.input :designation_account, collection: DesignationAccount.active
    end
    f.actions
  end
end
