# frozen_string_literal: true

class Xero::BalanceSheetService < Xero::BaseService
  def load
    balance_sheet.sections.each do |section|
      next unless section.title == 'Current Assets'

      section.rows.each do |row|
        next if row.cells.empty?

        designation_account = DesignationAccount.find_by(id: row.cells.first.attributes['account'], active: true)
        designation_account&.update(balance: -row.cells[1].value)
      end
    end
    true
  end

  private

  def balance_sheet
    @balance_sheet ||= client.BalanceSheet.get(date: Time.zone.now)
  rescue Xeroizer::OAuth::TokenExpired
    integration.refresh_access_token
    retry
  rescue Xeroizer::OAuth::RateLimitExceeded
    sleep 60
    retry
  end
end
