ActiveAdmin.register User::Permission do
  menu label: 'Permissions', parent: 'Users'
  permit_params :user_id, :designation_profile_id

  index do
    selectable_column
    id_column
    column :user
    column :designation_profile
    column :created_at
    actions
  end

  filter :user
  filter :designation_profile
  filter :created_at
end
