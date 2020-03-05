# frozen_string_literal: true

class Integration::Xero::DonorAccountsService < Integration::Xero::BaseService
  def sync
    contact_scope.each do |contact|
      record = integration.organization.donor_accounts.find_or_initialize_by(remote_id: contact.contact_id)
      record.attributes = donor_account_attributes(contact)
      record.save!
    end
  end

  private

  def contact_scope
    client.get_contacts(integration.primary_tenant_id, if_modified_since: integration.last_downloaded_at).contacts
  rescue XeroRuby::ApiError => e
    should_retry(e) ? retry : raise
  end

  def donor_account_attributes(contact)
    { name: contact.name, updated_at: contact.updated_date_utc }
  end
end
