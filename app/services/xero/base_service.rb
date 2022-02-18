# frozen_string_literal: true

class Xero::BaseService
  attr_accessor :integration, :modified_since, :all

  def self.load(integration, modified_since, all:)
    service = new
    service.integration = integration
    service.modified_since = modified_since
    service.all = all
    service.load
  end

  def load; end

  delegate :client, to: :integration
end
