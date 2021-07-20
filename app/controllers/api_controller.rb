# frozen_string_literal: true

class ApiController < ActionController::API
  set_current_tenant_through_filter
  before_action :set_current_organization_as_tenant

  def set_current_organization_as_tenant
    set_current_tenant(current_organization)
  end

  def current_organization
    @current_organization ||= Organization.friendly.find(params[:organization_id])
  end
end
