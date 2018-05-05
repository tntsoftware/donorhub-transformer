ActiveAdmin.register DesignationAccount do
  actions :index, :show, :edit, :update
  permit_params :sync_donations

  scope :active, default: true
  scope :inactive
  scope :all

  index do
    selectable_column
    id_column
    column :name
    column :sync_donations
    column :created_at
    actions
  end

  filter :name
  filter :sync_donations
  filter :created_at

  form do |f|
    f.inputs 'Designation Account Details' do
      f.input :sync_donations
    end
    f.actions
  end
end
