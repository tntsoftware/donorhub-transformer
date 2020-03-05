# frozen_string_literal: true

class Integration::Xero::SyncService
  def self.sync(integration)
    # Integration::Xero::DonorAccountsService.sync(integration)
    # Integration::Xero::DesignationAccountsService.sync(integration)
    Integration::Xero::DonationsService.sync(integration)
    Integration::Xero::DesignationAccount::BalancesService.sync(integration)
  end
end
