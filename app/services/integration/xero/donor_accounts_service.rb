# frozen_string_literal: true

class Integration::Xero::DonorAccountsService < Integration::Xero::BaseService
  def load
    contact_scope.each do |contact|
      record = integration.organization.donor_accounts.find_or_initialize_by(id: contact.id)
      record.attributes = donor_account_attributes(contact)
      record.save!
    end
  end

  private

  def contact_scope
    client.get_contacts(integration.tenant_id, if_modified_since: integration.last_downloaded_at)
  rescue XeroRuby::ApiError => e
    if e.code == 429 # Too Many Requests
      sleep 60
      retry
    end
  end

  def donor_account_attributes(contact)
    { id: account.id, name: account.name, updated_at: contact.updated_date_utc }
  end
end
