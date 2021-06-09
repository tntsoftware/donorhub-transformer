# frozen_string_literal: true

# Required to opt into this behavior
class ApplicationController < ActionController::Base
  set_current_tenant_through_filter
  before_action :set_current_organization_as_tenant

  def set_current_organization_as_tenant
    set_current_tenant(current_organization)
  end

  def current_organization
    @current_organization ||= Organization.find_by(subdomain: request.subdomain)
  end

  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception, prepend: true

  def authenticate_admin_user!
    raise SecurityError unless current_user.try(:admin?)
  end

  rescue_from SecurityError do |_exception|
    redirect_to root_url
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[email name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[email name])
  end
end
