ActiveAdmin.register DesignationProfile do
  permit_params :name

  index do
    selectable_column
    id_column
    column :name
    column :created_at
    actions
  end

  filter :name
  filter :created_at
end
