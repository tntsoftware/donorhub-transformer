# frozen_string_literal: true

class Integration::Xero::DesignationAccount::BalancesService < Integration::Xero::BaseService
  def sync
    balance_sheet.sections.each do |section|
      next unless section.title == 'Current Assets'

      section.rows.each do |row|
        next if row.cells.empty?

        designation_account =
          integration.designation_accounts.find_by(id: row.cells.first.attributes['account'], active: true)
        designation_account&.update(balance: -row.cells[1].value)
      end
    end
  end

  private

  def balance_sheet
    client.get_report_balance_sheet(integration.primary_tenant_id, date: Date.today.to_s)
  rescue XeroRuby::ApiError => e
    should_retry(e) ? retry : raise
  end
end
