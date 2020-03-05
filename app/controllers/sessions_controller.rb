# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    auth_hash = request.env['omniauth.auth']
    case auth_hash[:provider]
    when :xero_oauth2
      Integration::Xero::CreateService.create(current_organization, auth_hash)
    end
    redirect_to "#{request.env['omniauth.origin']}admin"
  end

  protected

  def current_organization
    @current_organization ||= ::Organization.find_by!(
      subdomain: URI.parse(request.env['omniauth.origin']).host.split('.').first
    )
  end
end
