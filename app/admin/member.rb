# frozen_string_literal: true

ActiveAdmin.register Member do
  belongs_to :organization, finder: :find_by_slug!
  navigation_menu :organization
  permit_params :name, :email

  index do
    id_column
    column :name
    column :email
    column :created_at
    actions
  end

  filter :name
  filter :email
  filter :created_at

  member_action :send_email, method: :put do
    resource.send_inform_email
    redirect_to admin_member_path(resource), notice: 'Email sent successfully!'
  end

  action_item :send_email, only: :show do
    link_to 'Send Email to Member', send_email_admin_organization_member_path(current_organization, member),
            method: :put
  end

  action_item :invite_member, only: :index do
    link_to 'Invite Member', new_invitation_admin_organization_members_path(current_organization)
  end

  collection_action :new_invitation do
    @user = User.new
  end

  collection_action :send_invitation, method: :post do
    @user = User.find_by(email: params[:user][:email])
    @user ||= User.invite!(params.require(:user).permit(:name, :email), current_user)
    if @user.errors.empty?
      @user.add_role(:member, current_organization)
      flash[:notice] = 'User has been successfully invited.'
      redirect_to admin_organization_members_path(current_organization)
    else
      messages = @user.errors.full_messages.map { |msg| msg }.join
      flash[:error] = "Error: #{messages}"
      redirect_to new_invitation_admin_organization_members_path(current_organization)
    end
  end
end
