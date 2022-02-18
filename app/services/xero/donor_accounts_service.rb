# frozen_string_literal: true

class Xero::DonorAccountsService < Xero::BaseService
  def load
    contact_scope.each do |contact|
      attributes = donor_account_attributes(contact)
      record = DonorAccount.find_or_initialize_by(remote_id: attributes[:remote_id])
      record.attributes = attributes
      record.save!
    end
  end

  private

  def contact_scope
    return client.Contact.all if all

    client.Contact.all(modified_since: modified_since)
  rescue Xeroizer::OAuth::TokenExpired
    integration.refresh_access_token
    retry
  rescue Xeroizer::OAuth::RateLimitExceeded
    sleep 60
    retry
  end

  def donor_account_attributes(contact, attributes = {})
    attributes[:remote_id] = contact.id
    attributes[:name] = contact.name
    attributes[:updated_at] = contact.updated_date_utc
    attributes
  end
end
