# frozen_string_literal: true

class Integration::Xero::Sync::DesignationAccount::BalancesService < Integration::Xero::Sync::BaseService
  def sync
    rows.each do |row|
      next if row.attributes.nil?

      designation_account =
        integration.organization.designation_accounts.find_by(remote_id: row.attributes[0].value)
      designation_account&.update(balance: -row.value.to_f)
    end
  end

  private

  def rows
    balance_sheet.map(&:rows)
                 .flatten
                 .select { |row| row&.row_type == 'Row' }
                 .map { |row| row.cells.last }
                 .flatten
  end

  def balance_sheet
    client.get_report_balance_sheet(integration.primary_tenant_id, date: Date.today.to_s).reports.first.rows
  rescue XeroRuby::ApiError => e
    should_retry(e) ? retry : raise
  end
end
