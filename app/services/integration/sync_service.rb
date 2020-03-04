# frozen_string_literal: true

class Integration::SyncService
  def self.sync(integration)
    return unless integration.locked_at.nil?

    update_columns(locked_at: Time.current, download_attempted_at: Time.current)
    "#{integration.class}::SyncService".constantize.sync(integration)
    update_columns(downloaded_at: Time.current)
  ensure
    update_columns(locked_at: nil)
  end
end
