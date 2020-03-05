# frozen_string_literal: true

class Integration::Xero::CreateService
  def self.create(organization, auth_hash)
    integration = organization.integrations.find_or_initialize_by(
      remote_id: auth_hash[:uid], type: 'Integration::Xero'
    ).becomes(Integration::Xero)
    primary_tenant_id =
      auth_hash[:extra][:xero_tenants].length == 1 ? auth_hash[:extra][:xero_tenants][0][:tenantId] : nil
    integration.attributes = {
      access_token: auth_hash[:credentials][:token],
      refresh_token: auth_hash[:credentials][:refresh_token],
      expires_at: Time.at(auth_hash[:credentials][:expires_at]),
      auth_hash: auth_hash,
      primary_tenant_id: primary_tenant_id,
      tenants: auth_hash[:extra][:xero_tenants]
    }
    integration.save!
  end
end
