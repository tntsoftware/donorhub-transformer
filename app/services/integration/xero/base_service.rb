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
    @client ||= ::XeroRuby::AccountingApi.new(
      ::XeroRuby::ApiClient.new(
        ::XeroRuby::Configuration.new(
          access_token: integration.access_token
        )
      )
    )
  end
end
