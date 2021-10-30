# frozen_string_literal: true

ActiveAdmin.register DesignationAccount do
  belongs_to :organization, finder: :find_by_slug!
  navigation_menu :organization
  actions :index, :show, :edit, :update
  permit_params :active

  scope :active, default: true
  scope :inactive
  scope :all

  index do
    selectable_column
    id_column
    column :name
    column :active
    column :created_at
    actions
  end

  filter :name
  filter :active
  filter :created_at

  form do |f|
    f.inputs 'Designation Account Details' do
      f.input :active
    end
    f.actions
  end
end
