# frozen_string_literal: true

ActiveAdmin.register DesignationAccount do
  belongs_to :organization, finder: :find_by_slug!
  navigation_menu :organization
  permit_params :name

  index do
    id_column
    column :name
    column :created_at
    actions
  end

  filter :name
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name
    end
    f.actions
  end
end
