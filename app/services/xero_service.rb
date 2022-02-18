# frozen_string_literal: true

class XeroService
  def initialize(integration)
    @integration = integration
  end

  def self.load(integration, modified_since = nil, all: false)
    modified_since = modified_since || integration.last_synced_at || Time.at(0).utc
    MultiTenant.with(integration.organization) do
      integration.refresh_access_token
      Xero::DonorAccountsService.load(integration, modified_since, all: all)
      Xero::DesignationAccountsService.load(integration, modified_since, all: all)
      Xero::DonationsService.load(integration, modified_since, all: all)
      Xero::BalanceSheetService.load(integration, modified_since, all: all)
    end
  end
end
