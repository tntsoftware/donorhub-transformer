# frozen_string_literal: true

class Integration < ApplicationRecord
  belongs_to :organization
  validates :type, inclusion: { in: ['Integration::Xero'] }
  attr_encrypted :access_token, key: ENV.fetch('INTEGRATION_ACCESS_TOKEN_ENCRYPTION_KEY')
  attr_encrypted :refresh_token, key: ENV.fetch('INTEGRATION_REFRESH_TOKEN_ENCRYPTION_KEY')

  def sync
    Integration::SyncJob.perform_later(id)
  end
end
