# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit
  after_action :verify_authorized, except: :index, if: :verify_authorized?
  after_action :verify_policy_scoped, only: :index, if: :verify_policy_scoped?
  set_current_tenant_through_filter
  before_action :set_current_organization_as_tenant
  helper_method :current_organization
  # rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  layout :layout

  protected

  # def render_not_found
  #   render 'not_found', status: :not_found
  # end

  def set_current_organization_as_tenant
    set_current_tenant(current_organization)
  end

  def current_organization
    @current_organization ||= Organization.friendly.find(params[:organization_id] || params[:id] || request.env['omniauth.origin'])
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def verify_authorized?
    !(is_a?(ActiveAdmin::BaseController) || devise_controller?)
  end

  def verify_policy_scoped?
    !(is_a?(ActiveAdmin::BaseController) || devise_controller?)
  end

  def layout
    if params[:controller] == 'devise/registrations' && %w[new create].include?(params[:action]) ||
       params[:controller] == 'devise/sessions' && %w[new create].include?(params[:action])
      'devise'
    else
      'application'
    end
  end
end
