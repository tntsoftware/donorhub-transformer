# frozen_string_literal: true

ActiveAdmin.register DesignationAccount do
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

  controller do
    def scoped_collection
      end_of_association_chain.where(organization: current_organization)
    end
  end
end
