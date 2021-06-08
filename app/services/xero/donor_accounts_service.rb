# frozen_string_literal: true

class Xero::DonorAccountsService < Xero::BaseService
  def load
    contact_scope.each do |contact|
      attributes = donor_account_attributes(contact)
      record = DonorAccount.find_or_initialize_by(id: attributes[:id])
      record.attributes = attributes
      record.save!
    end
  end

  private

  def contact_scope
    all ? client.Contact.all : client.Contact.all(modified_since: modified_since)
  rescue Xeroizer::OAuth::RateLimitExceeded
    sleep 60
    retry
  end

  def donor_account_attributes(contact, attributes = {})
    attributes[:id] = contact.id
    attributes[:name] = contact.name
    attributes[:updated_at] = contact.updated_date_utc
    attributes
  end
end
