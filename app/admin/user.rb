ActiveAdmin.register User do
  actions :all, except: %i[new create]
  permit_params :name, :email, :role

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :role
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs 'User Details' do
      f.input :name
      f.input :email
      f.input :role
    end
    f.actions
  end
end
