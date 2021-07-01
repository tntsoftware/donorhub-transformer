# frozen_string_literal: true

class Integration::Xero < Integration
  store_accessor :payload, :name, :access_token, :refresh_token, :tenant_id, :expires_at, :id_token

  def self.find_or_create_by_omniauth(auth_hash)
    integration = find_or_initialize_by(remote_id: auth_hash['uid'])
    integration.attributes = {
      name: auth_hash['info']['name'],
      id_token: auth_hash['extra']['id_token'],
      access_token: auth_hash['credentials']['token'],
      refresh_token: auth_hash['credentials']['refresh_token'],
      tenant_id: auth_hash['extra']['xero_tenants'][0]['tenantId']
    }
    integration.save
    integration
  end

  def client
    return @client if @client

    @client = Xeroizer::OAuth2Application.new(
      ENV['XERO_API_CLIENT_ID'],
      ENV['XERO_API_CLIENT_SECRET'],
      access_token: access_token,
      refresh_token: refresh_token,
      tenant_id: tenant_id,
      rate_limit_sleep: 60
    )
  end

  def refresh_access_token
    new_token_set = client.renew_access_token
    update(
      id_token: new_token_set['id_token'],
      access_token: new_token_set.token,
      refresh_token: new_token_set.refresh_token
    )
  end
end
