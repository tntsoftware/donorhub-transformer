# frozen_string_literal: true

ActiveAdmin.register DesignationAccount do
  belongs_to :organization, finder: :find_by_slug!
  navigation_menu :organization
  permit_params :name, :active

  scope :active, default: true
  scope :inactive
  scope :all

  index do
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
    f.inputs do
      f.input :name
      f.input :active
    end
    f.actions
  end
end
