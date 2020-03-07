# frozen_string_literal: true

class Integration::Xero::BaseService
  attr_accessor :integration

  def self.sync(integration)
    new(integration).sync
  end

  def initialize(integration)
    self.integration = integration
  end

  def sync; end

  protected

  def client
    @client ||=
      ::XeroRuby::AccountingApi.new(
        ::XeroRuby::ApiClient.new(
          ::XeroRuby::Configuration.new { |config| config.access_token = integration.access_token }
        )
      )
  end

  def should_retry(exception)
    case exception.code
    when 401
      unauthorized(exception)
    when 429
      too_many_requests(exception)
    else
      false
    end
  end

  def unauthorized(exception)
    return false unless JSON.parse(exception.response_body)['Detail'].starts_with?('TokenExpired')

    @client = nil
    Integration::Xero::RefreshService.refresh?(integration)
  end

  def too_many_requests(_exception)
    sleep 60
    true
  end
end
