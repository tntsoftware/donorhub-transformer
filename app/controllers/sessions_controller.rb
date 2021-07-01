# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    integration = current_organization.xero_integrations.find_or_create_by_omniauth(request.env['omniauth.auth'])

    redirect_to edit_admin_integration_path(integration)
  end

  def indexable_controller?
    true
  end
end
