# frozen_string_literal: true

class Xero::BalanceSheetService < BaseService
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
    @balance_sheet ||= client.BalanceSheet.get(date: Time.now)
  rescue Xeroizer::OAuth::RateLimitExceeded
    sleep 60
    retry
  end
end
