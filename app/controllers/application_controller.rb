# frozen_string_literal: true

class ApplicationController < ActionController::Base
  set_current_tenant_through_filter
  before_action :set_current_organization_as_tenant
  helper_method :current_organization

  protected

  def set_current_organization_as_tenant
    set_current_tenant(current_organization)
  end

  def current_organization
    @current_organization ||=
      Organization.friendly.find(params[:organization_id] || params[:id] || request.env['omniauth.origin'])
  rescue ActiveRecord::RecordNotFound
    nil
  end
end
