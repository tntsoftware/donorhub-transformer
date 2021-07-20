# frozen_string_literal: true

class OrganizationsController < ApplicationController
  decorates_assigned :organizations, :organization
  before_action :authenticate_user!

  def index
    load_organizations

    return redirect_to action: :new if @organizations.size.zero?
    return redirect_to organization_path(@organizations.first) if @organizations.size == 1

    render(:index)
  end

  def new
    build_organization

    authorize @organization
  end

  def create
    build_organization
    authorize @organization

    return render 'new', status: :unprocessable_entity unless save_organization

    flash[:notice] = 'Organization created successfully.'
    @organization.members.create(user: current_user)
    redirect_to organization_path(@organization)
  end

  def show
    load_organization
    authorize @organization
  end

  def update
    load_organization
    build_organization
    authorize @organization
    return render 'edit', status: :unprocessable_entity unless save_organization

    flash[:notice] = 'organization updated successfully'
    redirect_to action: :edit
  end

  protected

  def build_organization
    @organization ||= Organization.new
    @organization.attributes = organization_params
  end

  def save_organization
    @organization.save
  end

  def load_organization
    @organization = current_user.organizations.friendly.find(params[:id])
  end

  def organization_params
    return {} unless params[:organization]

    params.require(:organization).permit(:name, :slug)
  end

  def load_organizations
    @organizations = organization_scope
  end

  def organization_scope
    policy_scope(current_user.organizations)
  end
end
