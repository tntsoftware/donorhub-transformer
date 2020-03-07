# frozen_string_literal: true

class Integration::Xero::Sync::DonationsService < Integration::Xero::Sync::BaseService
  def sync
    donations = integration.organization.donations.where.not(id: donation_ids.flatten)
    if integration.last_downloaded_at
      donations = donations.where('donations.remote_updated_at >= ?', integration.last_downloaded_at)
    end
    donations.delete_all
  end

  private

  def donation_ids
    bank_transactions.map do |bank_transaction|
      bank_transaction.line_items.map do |line_item|
        attributes = attributes(bank_transaction, line_item)
        next unless attributes[:designation_account_id] && attributes[:donor_account_id]

        donation = integration.organization.donations.find_or_initialize_by(remote_id: attributes[:remote_id])
        donation.update!(attributes)
        donation.id
      end
    end
  end

  def bank_transactions
    page = 1
    Enumerator.new do |enumerable|
      loop do
        data = call_bank_transaction_api(page)
        data.each { |element| enumerable.yield element }
        break if data.empty?

        page += 1
      end
    end
  end

  def call_bank_transaction_api(page)
    client.get_bank_transactions(
      integration.primary_tenant_id,
      if_modified_since: integration.last_downloaded_at&.to_date || 2.years.ago.to_date,
      where: 'Type=="RECEIVE" and Status=="AUTHORISED"',
      page: page
    ).bank_transactions
  rescue XeroRuby::ApiError => e
    should_retry(e) ? retry : raise
  end

  def attributes(bank_transaction, line_item)
    {
      remote_id: line_item.line_item_id,
      designation_account_id: designation_account_id_by_code(line_item.account_code),
      donor_account_id: donor_account_id_by_remote_id(bank_transaction.contact.contact_id),
      remote_updated_at: bank_transaction.updated_date_utc,
      created_at: bank_transaction.date,
      amount: line_item.line_amount,
      currency: bank_transaction.currency_code
    }
  end

  def designation_account_id_by_code(code)
    @designation_accounts ||= Hash[integration.organization.designation_accounts.active.pluck(:code, :id)]
    @designation_accounts[code]
  end

  def donor_account_id_by_remote_id(remote_id)
    @donor_accounts ||= Hash[integration.organization.donor_accounts.pluck(:remote_id, :id)]
    @donor_accounts[remote_id]
  end
end
