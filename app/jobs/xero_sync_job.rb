class XeroSyncJob < ApplicationJob
  def perform(modified_since = Time.zone.now.beginning_of_month - 2.months)
    @modified_since = modified_since
    donor_accounts
    designation_accounts
    donations
  end

  protected

  def donor_accounts
    contact_scope.each do |contact|
      record = DonorAccount.find_or_initialize_by(id: contact.id)
      record.update!(donor_account_attributes(contact))
    end
  end

  def contact_scope
    client.Contact.all
  rescue Xeroizer::OAuth::RateLimitExceeded
    sleep 60
    retry
  end

  def donor_account_attributes(contact)
    attributes = contact.to_h
    attributes.select { |k, _v| DonorAccount.new.attributes.keys.member?(k.to_s) }
  end

  def designation_accounts
    account_scope.each do |account|
      record = DesignationAccount.find_or_initialize_by(id: account.id)
      record.update!(designation_account_attributes(account))
    end
  end

  def account_scope
    client.Account.all
  rescue Xeroizer::OAuth::RateLimitExceeded
    sleep 60
    retry
  end

  def designation_account_attributes(account)
    attributes = account.to_h
    attributes[:klass] = attributes[:class]
    attributes[:account_type] = attributes[:type]
    attributes.select { |k, _v| DesignationAccount.new.attributes.keys.member?(k.to_s) }
  rescue Xeroizer::OAuth::RateLimitExceeded
    sleep 60
    retry
  end

  def donations
    bank_transaction_scope.each do |bank_transaction|
      bank_transaction.line_items.each do |line_item|
        next unless designation_account_codes.keys.include?(line_item.account_code)
        record = Donation.find_or_initialize_by(id: line_item.line_item_id)
        record.update!(donation_attributes(line_item, bank_transaction))
      end
    end
  end

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
      modified_since: @modified_since, where: 'Type=="RECEIVE" and Status=="AUTHORISED"', page: page
    )
  rescue Xeroizer::OAuth::RateLimitExceeded
    sleep 60
    retry
  end

  def donation_attributes(line_item, bank_transaction)
    attributes = line_item.to_h
    attributes[:designation_account_id] = designation_account_codes[attributes[:account_code]]
    attributes[:created_at] = bank_transaction.date
    attributes[:donor_account_id] = bank_transaction.contact.id
    attributes.select { |k, _v| Donation.new.attributes.keys.member?(k.to_s) }
  rescue Xeroizer::OAuth::RateLimitExceeded
    sleep 60
    retry
  end

  def designation_account_codes
    return @designation_account_codes if @designation_account_codes
    @designation_account_codes = {}
    DesignationAccount.active.each do |designation_account|
      @designation_account_codes[designation_account.code] = designation_account.id
    end
    @designation_account_codes
  end

  def client
    @client ||=
      Xeroizer::PrivateApplication.new(
        ENV.fetch('XERO_OAUTH_CONSUMER_KEY'),
        ENV.fetch('XERO_OAUTH_CONSUMER_SECRET'),
        nil,
        private_key: ENV.fetch('XERO_PRIVATE_KEY')
      )
  end
end
