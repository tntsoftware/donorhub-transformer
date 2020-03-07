# frozen_string_literal: true

class Integration::Xero::Sync::DesignationAccount::BalancesService < Integration::Xero::Sync::BaseService
  protected

  def import_remote_record(remote_record)
    attributes = attributes(remote_record)
    scope.find_by(remote_id: attributes[:remote_id])&.update!(attributes)
  end

  def scope
    integration.organization.designation_accounts
  end

  def attributes(remote_record)
    { remote_id: remote_record.attributes[0].value, balance: -remote_record.value.to_f }
  end

  def remote_collection
    filter(
      client.get_report_balance_sheet(integration.primary_tenant_id, date: Date.today.to_s)
            .reports[0]
            .rows
    )
  end

  private

  def filter(report)
    report
      .map(&:rows)
      .flatten
      .select { |row| row&.row_type == 'Row' }
      .map { |row| row.cells.last }
      .flatten
      .reject { |row| row.attributes.nil? }
  end
end
