# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit
  after_action :verify_authorized, except: :index, unless: :indexable_controller?
  after_action :verify_policy_scoped, only: :index, unless: :indexable_controller?
  set_current_tenant_through_filter
  before_action :set_current_organization_as_tenant
  helper_method :current_organization
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  layout :layout

  protected

  def render_not_found
    render 'not_found', status: :not_found
  end

  def set_current_organization_as_tenant
    set_current_tenant(current_organization)
  end

  def current_organization
    @current_organization ||= Organization.friendly.find(params[:organization_id] || params[:id] || request.env['omniauth.origin'])
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def indexable_controller?
    is_a?(ActiveAdmin::BaseController) || devise_controller?
  end

  def layout
    if params[:controller] == 'devise/registrations' && params[:action] == 'new' ||
       params[:controller] == 'devise/sessions' && params[:action] == 'new'
      'devise'
    else
      'application'
    end
  end
end
