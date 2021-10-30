# frozen_string_literal: true

ActiveAdmin.register Organization do
  actions :all, except: %i[new create destroy]

  sidebar 'Resources', only: %i[show] do
    ul do
      li link_to 'Designation Accounts', admin_organization_designation_accounts_path(resource)
      li link_to 'Designation Profiles', admin_organization_designation_profiles_path(resource)
      li link_to 'Donations', admin_organization_donations_path(resource)
      li link_to 'Integrations', admin_organization_integrations_path(resource)
      li link_to 'Members', admin_organization_members_path(resource)
    end
  end

  filter :name

  index do
    selectable_column
    id_column
    column :name
    column :created_at
    column :updated_at
    actions
  end
end
