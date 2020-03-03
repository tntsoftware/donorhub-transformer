# frozen_string_literal: true

class ApiController < ActionController::API
  def current_organization
    Organization.find_by(subdomain: request.subdomain)
  end
end
