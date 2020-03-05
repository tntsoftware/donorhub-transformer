# frozen_string_literal: true

class Integration::Xero::DonationsService < Integration::Xero::BaseService
  def sync
    donation_ids = pull_donations
    donations = integration.organization.donations.where.not(id: donation_ids)
    if integration.last_downloaded_at
      donations = donations.where('donations.updated_at >= ?', integration.last_downloaded_at)
    end
    donations.delete_all
  end

  private

  def pull_donations
    donation_ids = []
    bank_transactions.each do |bank_transaction|
      bank_transaction.line_items.each do |line_item|
        donation = integration.organization.donations.find_or_initialize_by(remote_id: line_item.line_item_id)
        donation.attributes = donation_attributes(line_item, bank_transaction)
        next if donation.designation_account_id.nil? || donation.donor_account_id.nil?

        donation.save!

        donation_ids << donation.id
      end
    end
    donation_ids
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
      if_modified_since: integration.last_downloaded_at&.to_date,
      where: 'Type=="RECEIVE" and Status=="AUTHORISED"',
      page: page
    ).bank_transactions
  rescue XeroRuby::ApiError => e
    should_retry(e) ? retry : raise
  end

  def donation_attributes(line_item, bank_transaction)
    {
      designation_account_id: designation_account_id_by_code(line_item.account_code),
      created_at: bank_transaction.date,
      updated_at: bank_transaction.updated_date_utc,
      donor_account_id: donor_account_id_by_remote_id(bank_transaction.contact.contact_id),
      currency: bank_transaction.currency_code,
      amount: line_item.line_amount
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
