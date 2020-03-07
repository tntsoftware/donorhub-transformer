# frozen_string_literal: true

class Integration::Xero::CreateService
  attr_reader :organization, :auth_hash

  def self.create(organization, auth_hash)
    new(organization, auth_hash).create
  end

  def initialize(organization, auth_hash)
    @organization = organization
    @auth_hash = auth_hash
  end

  def create
    integration.update!(attributes)
  end

  protected

  def attributes
    {
      access_token: auth_hash[:credentials][:token],
      refresh_token: auth_hash[:credentials][:refresh_token],
      expires_at: Time.at(auth_hash[:credentials][:expires_at]),
      auth_hash: auth_hash,
      primary_tenant_id: primary_tenant_id,
      tenants: auth_hash[:extra][:xero_tenants]
    }
  end

  def primary_tenant_id
    auth_hash[:extra][:xero_tenants].length == 1 ? auth_hash[:extra][:xero_tenants][0][:tenantId] : nil
  end

  def integration
    @integration ||= organization.integrations.find_or_initialize_by(
      remote_id: auth_hash[:uid], type: 'Integration::Xero'
    ).becomes(Integration::Xero)
  end
end
