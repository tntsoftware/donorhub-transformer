# frozen_string_literal: true

class Integration::Xero::DonorAccountsService < Integration::Xero::BaseService
  protected

  def scope
    integration.organization.donor_accounts
  end

  def remote_collection
    client.get_contacts(
      integration.primary_tenant_id,
      if_modified_since: integration.last_downloaded_at&.to_date
    ).contacts
  end

  def attributes(contact)
    { remote_id: contact.contact_id, name: contact.name, updated_at: contact.updated_date_utc }
  end
end
