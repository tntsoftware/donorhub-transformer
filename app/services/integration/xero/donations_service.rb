# frozen_string_literal: true

class Integration::Xero::DonationsService < Integration::Xero::BaseService
  def sync
    donation_ids = []
    DesignationAccount.where(active: true).pluck(:remote_id).each do |account_code|
      bank_transaction_scope(account_code: account_code).each do |bank_transaction|
        bank_transaction.line_items.each do |line_item|
          attributes = donation_attributes(line_item, bank_transaction)
          donation = integration.organizations.donations.find_or_initialize_by(id: line_item.line_item_id)
          donation.attributes = attributes
          donation.save!
          donation_ids << donation.id
        end
      end
    end
    donations = integration.organization.donations.where.not(id: donation_ids)
    donations = donations.where('updated_at >= ?', last_downloaded_at) if last_downloaded_at
    donations.delete_all
  end

  private

  def bank_transaction_scope(page: 1, account_code:)
    Enumerator.new do |enumerable|
      loop do
        data = call_bank_transaction_api(page, account_code)
        data.each { |element| enumerable.yield element }
        break if data.empty?

        page += 1
      end
    end
  end

  def call_bank_transaction_api(page, account_code)
    client.get_bank_transactions(
      integration.tenant_id,
      if_modified_since: last_downloaded_at,
      where: "Type==\"RECEIVE\" and Status==\"AUTHORISED\" and LineItems[0].AccountCode==\"#{account_code}\"",
      page: page
    )
  rescue XeroRuby::ApiError => e
    if e.code == 429 # Too Many Requests
      sleep 60
      retry
    end
  end

  def donation_attributes(line_item, bank_transaction)
    {
      id: line_item.line_item_id,
      designation_account_id: designation_account_codes[line_item.account_code],
      created_at: bank_transaction.date,
      updated_at: bank_transaction.updated_date_utc,
      donor_account_id: bank_transaction.contact.id,
      currency: bank_transaction.currency_code,
      amount: line_item.line_amount
    }
  end

  def designation_account_codes
    return @designation_account_codes if @designation_account_codes

    @designation_account_codes = {}
    integration.organization.designation_accounts.where(active: true).each do |designation_account|
      @designation_account_codes[designation_account.remote_id] = designation_account.id
    end
    @designation_account_codes
  end
end
