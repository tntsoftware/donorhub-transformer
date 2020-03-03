# frozen_string_literal: true

class Integration::Xero::DesignationAccountsService < Integration::Xero::BaseService
  def sync
    account_scope.each do |account|
      record = inegration.organization.designation_accounts.find_or_initialize_by(id: account.id)
      record.attributes = designation_account_attributes(account)
      record.save!
    end
  end

  private

  def account_scope
    client.get_accounts(integration.tenant_id, if_modified_since: integration.last_downloaded_at)
  rescue XeroRuby::ApiError => e
    if e.code == 429 # Too Many Requests
      sleep 60
      retry
    end
  end

  def designation_account_attributes(account)
    { id: account.id, name: account.name, remote_id: account.code }
  end
end
