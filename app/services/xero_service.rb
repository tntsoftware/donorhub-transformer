# frozen_string_literal: true

class XeroService
  def self.load(modified_since = Time.zone.now.beginning_of_month - 2.months, all: false)
    Xero::DonorAccountsService.load(modified_since, all: all)
    Xero::DesignationAccountsService.load(modified_since, all: all)
    Xero::DonationsService.load(modified_since, all: all)
    Xero::BalanceSheetService.load(modified_since, all: all)
  end
end
