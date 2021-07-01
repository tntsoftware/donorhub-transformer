# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit
  # after_action :verify_authorized, except: :index, unless: :indexable_controller?
  # after_action :verify_policy_scoped, only: :index, unless: :indexable_controller?
  set_current_tenant_through_filter
  before_action :set_current_organization_as_tenant
  helper_method :current_organization

  def set_current_organization_as_tenant
    set_current_tenant(current_organization)
  end

  def current_organization
    @current_organization ||= Organization.find_by(slug: params[:slug])
  end

  def indexable_controller?
    is_a?(ActiveAdmin::BaseController) || devise_controller?
  end
end
