# frozen_string_literal: true

class Integration::Xero::Sync::DesignationAccountsService < Integration::Xero::Sync::BaseService
  protected

  def scope
    integration.organization.designation_accounts
  end

  def remote_collection
    client.get_accounts(
      integration.primary_tenant_id,
      if_modified_since: integration.last_downloaded_at&.to_date
    ).accounts
  end

  def attributes(account)
    {
      remote_id: account.account_id,
      name: account.name,
      code: account.code,
      remote_updated_at: account.updated_date_utc
    }
  end
end
