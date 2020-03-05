# frozen_string_literal: true

class Integration::PrimarySyncService
  def self.sync(integration)
    return unless integration.locked_at.nil?

    begin
      integration.update_columns(locked_at: Time.current, last_download_attempted_at: Time.current)
      "#{integration.class}::SyncService".constantize.sync(integration)
      integration.update_columns(last_downloaded_at: Time.current)
    ensure
      integration.update_columns(locked_at: nil)
    end
  end
end
