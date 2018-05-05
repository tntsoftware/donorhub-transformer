class XeroService
  def self.load(modified_since = Time.zone.now.beginning_of_month - 2.months)
    Xero::DonorAccountsService.load(modified_since)
    Xero::DesignationAccountsService.load(modified_since)
    Xero::DonationsService.load(modified_since)
  end
end
