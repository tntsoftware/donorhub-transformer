# frozen_string_literal: true

class Integration::Xero::SyncService
  def self.sync(integration)
    Integration::Xero::Sync::DonorAccountsService.sync(integration)
    Integration::Xero::Sync::DesignationAccountsService.sync(integration)
    Integration::Xero::Sync::DonationsService.sync(integration)
    Integration::Xero::Sync::DesignationAccount::BalancesService.sync(integration)
  end
end
