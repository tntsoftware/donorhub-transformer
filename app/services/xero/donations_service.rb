module Xero
  class DonationsService < BaseService
    def load
      donation_ids = []
      bank_transaction_scope.each do |bank_transaction|
        bank_transaction.line_items.each do |line_item|
          next unless designation_account_codes.key?(line_item.account_code)
          attributes = donation_attributes(line_item, bank_transaction)
          donation = Donation.find_or_initialize_by(id: line_item.line_item_id)
          donation.attributes = attributes
          donation.save!
          donation_ids << donation.id
        end
      end
      Donation.where("updated_at >= ?", @modified_since).where.not(id: donation_ids).delete_all
    end

    private

    def bank_transaction_scope(page = 1)
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
      client.BankTransaction.all(
        modified_since: @modified_since,
        where: 'Type=="RECEIVE" and Status=="AUTHORISED"',
        page: page,
      )
    rescue Xeroizer::OAuth::RateLimitExceeded
      sleep 60
      retry
    end

    def donation_attributes(line_item, bank_transaction, attributes = {})
      attributes[:id] = line_item.line_item_id
      attributes[:designation_account_id] = designation_account_codes[line_item.account_code]
      attributes[:created_at] = bank_transaction.date
      attributes[:updated_at] = bank_transaction.updated_date_utc
      attributes[:donor_account_id] = bank_transaction.contact.id
      attributes[:currency] = bank_transaction.currency_code
      attributes[:amount] = line_item.line_amount
      attributes
    rescue Xeroizer::OAuth::RateLimitExceeded
      sleep 60
      retry
    end

    def designation_account_codes
      return @designation_account_codes if @designation_account_codes
      @designation_account_codes = {}
      DesignationAccount.where(active: true).each do |designation_account|
        @designation_account_codes[designation_account.remote_id] = designation_account.id
      end
      @designation_account_codes
    end
  end
end
