# frozen_string_literal: true

class Integration < ApplicationRecord
  self.abstract_class = true

  belongs_to :organization
  attr_encrypted :access_token, key: ENV.fetch('INTEGRATION_ACCESS_TOKEN_ENCRYPTION_KEY')
  attr_encrypted :refresh_token, key: ENV.fetch('INTEGRATION_REFRESH_TOKEN_ENCRYPTION_KEY')

  def sync
    "#{self.class}::SyncService".constantize.sync(self)
  end
end
