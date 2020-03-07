# frozen_string_literal: true

class Integration::Xero::Sync::BaseService
  attr_accessor :integration

  def self.sync(integration)
    new(integration).sync
  end

  def initialize(integration)
    self.integration = integration
  end

  def sync
    remote_collection_with_exception_handling.each do |remote_record|
      attributes = attributes(remote_record)
      scope.find_or_initialize_by(remote_id: attributes[:remote_id]).update!(attributes)
    end
  end

  protected

  def remote_collection_with_exception_handling
    remote_collection
  rescue XeroRuby::ApiError => e
    should_retry(e) ? retry : raise
  end

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
