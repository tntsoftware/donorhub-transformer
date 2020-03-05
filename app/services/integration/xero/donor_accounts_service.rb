# frozen_string_literal: true

class Integration::Xero::DonorAccountsService < Integration::Xero::BaseService
  def sync
    contacts.each do |contact|
      donor_account = integration.organization.donor_accounts.find_or_initialize_by(remote_id: contact.contact_id)
      donor_account.attributes = donor_account_attributes(contact)
      donor_account.save!
    end
  end

  private

  def contacts
    client.get_contacts(
      integration.primary_tenant_id,
      if_modified_since: integration.last_downloaded_at&.to_date
    ).contacts
  rescue XeroRuby::ApiError => e
    should_retry(e) ? retry : raise
  end

  def donor_account_attributes(contact)
    { name: contact.name, updated_at: contact.updated_date_utc }
  end
end
