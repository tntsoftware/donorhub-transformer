# frozen_string_literal: true

class Integration::Xero::RefreshService
  attr_reader :integration

  def self.refresh?(integration)
    new(integration).refresh?
  end

  def initialize(integration)
    @integration = integration
  end

  def refresh?
    integration.update(attributes)
    true
  rescue RestClient::ExceptionWithResponse => e
    raise unless e.response.code == 400 && JSON.parse(e.response.body)['error'] == 'invalid_grant'

    integration.update(valid_credentials: false)
    false
  end

  protected

  def attributes
    payload = JSON.parse(response.body)
    {
      expires_at: Time.current + payload['expires_in'],
      access_token: payload['access_token'],
      refresh_token: payload['refresh_token'],
      valid_credentials: true
    }
  end

  def response
    @response = RestClient.post(
      'https://identity.xero.com/connect/token',
      { grant_type: 'refresh_token', refresh_token: integration.refresh_token },
      { authorization: authorization, accept: :json }
    )
  end

  def authorization
    "Basic #{Base64.strict_encode64("#{ENV.fetch('XERO_API_CLIENT_ID')}:#{ENV.fetch('XERO_API_CLIENT_SECRET')}")}"
  end
end
