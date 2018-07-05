ActiveAdmin.register Member do
  permit_params :name, :email

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :created_at
    actions
  end

  filter :name
  filter :email
  filter :created_at

  form do |f|
    f.inputs "Member Details" do
      f.input :name
      f.input :email
    end
    f.actions
  end
end
