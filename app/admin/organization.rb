# frozen_string_literal: true

ActiveAdmin.register Organization do
  actions :all, except: %i[destroy]

  permit_params :name, :abbreviation, :account_help_url, :request_profile_url, :help_url, :help_description,
                :currency_code

  sidebar 'Resources', only: %i[show] do
    ul do
      if Pundit.policy(current_user, DesignationAccount.new).index?
        li link_to 'Designation Accounts', admin_organization_designation_accounts_path(resource)
      end
      if Pundit.policy(current_user, DesignationProfile.new).index?
        li link_to 'Designation Profiles', admin_organization_designation_profiles_path(resource)
      end
      if Pundit.policy(current_user, DonorAccount.new).index?
        li link_to 'Donor Accounts', admin_organization_designation_profiles_path(resource)
      end
      if Pundit.policy(current_user, Donation.new).index?
        li link_to 'Donations', admin_organization_donations_path(resource)
      end
      if Pundit.policy(current_user, Integration.new).index?
        li link_to 'Integrations', admin_organization_integrations_path(resource)
      end
      li link_to 'Members', admin_organization_members_path(resource) if Pundit.policy(current_user, Member.new).index?
    end
  end

  filter :name

  index do
    id_column
    column :name
    column :created_at
    column :updated_at
    actions
  end

  controller do
    def create
      create! do
        current_user.add_role(:admin, resource)
        current_user.add_role(:member, resource)
        resource_path
      end
    end
  end
end
