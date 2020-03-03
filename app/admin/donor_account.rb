# frozen_string_literal: true

ActiveAdmin.register DonorAccount do
  actions :index, :show

  index do
    selectable_column
    id_column
    column :name
    column :created_at
    actions
  end

  filter :name
  filter :created_at

  controller do
    def scoped_collection
      end_of_association_chain.where(organization: current_organization)
    end
  end
end
