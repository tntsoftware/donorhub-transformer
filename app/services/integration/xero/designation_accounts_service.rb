# frozen_string_literal: true

class Integration::Xero::DesignationAccountsService < Integration::Xero::BaseService
  def sync
    accounts.each do |account|
      record = integration.organization.designation_accounts.find_or_initialize_by(remote_id: account.account_id)
      record.attributes = designation_account_attributes(account)
      record.save!
    end
  end

  private

  def accounts
    client.get_accounts(integration.primary_tenant_id, if_modified_since: integration.last_downloaded_at).accounts
  rescue XeroRuby::ApiError => e
    should_retry(e) ? retry : raise
  end

  def designation_account_attributes(account)
    { name: account.name, code: account.code }
  end
end
