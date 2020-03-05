# frozen_string_literal: true

class Integration < ApplicationRecord
  store :metadata
  serialize :auth_hash, Hash
  belongs_to :organization
  validates :type, inclusion: { in: ['Integration::Xero'] }
  attr_encrypted :access_token, key: [ENV.fetch('INTEGRATION_ACCESS_TOKEN_ENCRYPTION_KEY')].pack('H*')
  attr_encrypted :refresh_token, key: [ENV.fetch('INTEGRATION_REFRESH_TOKEN_ENCRYPTION_KEY')].pack('H*')

  def sync
    Integration::SyncJob.perform_later(id)
  end
end
