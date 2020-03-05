# frozen_string_literal: true

class Integration::Xero::BaseService
  attr_accessor :integration

  def initialize(integration)
    self.integration = integration
  end

  def self.sync(integration)
    new(integration).sync
  end

  def sync; end

  def client
    @client ||= ::XeroRuby::AccountingApi.new(::XeroRuby::ApiClient.new(config))
  end

  private

  def config
    @config ||= ::XeroRuby::Configuration.new do |config|
      config.access_token = integration.access_token
    end
  end

  def should_retry(exception)
    case exception.code
    when 401
      if JSON.parse(exception.response_body)['Detail'].starts_with?('TokenExpired')
        integration.refresh!
        @client = nil
        @config = nil
        false
      else
        false
      end
    when 429 # Too Many Requests
      sleep 60
      true
    else
      false
    end
  end
end
