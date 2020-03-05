# frozen_string_literal: true

class Integration::Xero < Integration
  store :metadata, accessors: %i[tenants primary_tenant_id]
  validates :tenants, presence: true

  def refresh!
    response = RestClient.post(
      'https://identity.xero.com/connect/token',
      {
        grant_type: 'refresh_token',
        refresh_token: refresh_token
      },
      {
        authorization: authorization,
        content_type: :json,
        accept: :json
      }
    )
    return unless response.code == 200

    payload = JSON.parse(response.body)
    update(
      expires_at: Time.at(payload['expires_in']),
      access_token: payload['access_token'],
      refresh_token: payload['refresh_token']
    )
  end

  protected

  def authorization
    "Basic #{Base64.strict_encode64("#{ENV.fetch('XERO_API_CLIENT_ID')}:#{ENV.fetch('XERO_API_CLIENT_SECRET')}")}"
  end
end
