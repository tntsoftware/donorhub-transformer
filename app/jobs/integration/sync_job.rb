# frozen_string_literal: true

class Integration::SyncJob < ApplicationJob
  def perform(integration_id)
    integration = Integration.find_by(id: integration_id)
    Integration::PrimarySyncService.sync(integration) if integration
  end
end
