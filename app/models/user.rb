# frozen_string_literal: true

class User < ApplicationRecord
  multi_tenant :organization
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, request_keys: [:subdomain]

  def self.find_for_authentication(warden_conditions)
    where(
      email: warden_conditions[:email],
      organization: Organization.find_by(subdomain: warden_conditions[:subdomain])
    ).first
  end
end
