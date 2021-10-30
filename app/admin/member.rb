# frozen_string_literal: true

ActiveAdmin.register Member do
  belongs_to :organization, finder: :find_by_slug!
  navigation_menu :organization
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
    f.inputs 'Member Details' do
      f.input :name
      f.input :email
    end
    f.actions
  end

  member_action :send_email, method: :put do
    resource.send_inform_email
    redirect_to admin_member_path(resource), notice: 'Email sent successfully!'
  end

  action_item :send_email, only: :show do
    link_to 'Send Email to Member', send_email_admin_organization_member_path(current_organization, member),
            method: :put
  end
end
