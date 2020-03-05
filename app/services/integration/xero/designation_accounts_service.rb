# frozen_string_literal: true

class Integration::Xero::DesignationAccountsService < Integration::Xero::BaseService
  def sync
    accounts.each do |account|
      designation_account =
        integration.organization.designation_accounts.find_or_initialize_by(remote_id: account.account_id)
      designation_account.attributes = designation_account_attributes(account)
      designation_account.save!
    end
  end

  private

  def accounts
    client.get_accounts(
      integration.primary_tenant_id,
      if_modified_since: integration.last_downloaded_at&.to_date
    ).accounts
  rescue XeroRuby::ApiError => e
    should_retry(e) ? retry : raise
  end

  def designation_account_attributes(account)
    { name: account.name, code: account.code, updated_at: account.updated_date_utc }
  end
end
