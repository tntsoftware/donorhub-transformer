# frozen_string_literal: true

class Xero::DonationsService < Xero::BaseService
  def load
    donation_ids = []
    bank_transaction_scope.each do |bank_transaction|
      bank_transaction.line_items.each do |line_item|
        line_item.tracking.each do |tracking|
          donation_ids << create_donation(tracking, line_item, bank_transaction)
        end
      end
    end
    delete_donations
  end

  private

  def delete_donations(exclude_ids)
    if all
      Donation.where.not(id: exclude_ids).delete_all
    else
      Donation.where('updated_at >= ?', modified_since).where.not(id: exclude_ids).delete_all
    end
  end

  def bank_transaction_scope(page: 1)
    Enumerator.new do |enumerable|
      loop do
        data = bank_transactions(page)
        data.each { |element| enumerable.yield element }
        break if data.empty?

        page += 1
      end
    end
  end

  def bank_transactions(page)
    if all
      client.BankTransaction.all(where: 'Type=="RECEIVE" and Status=="AUTHORISED"', page: page)
    else
      client.BankTransaction.all(
        modified_since: modified_since, where: 'Type=="RECEIVE" and Status=="AUTHORISED"', page: page
      )
    end
  end

  def donation_attributes(tracking, line_item, bank_transaction, _attributes = {})
    {
      remote_id: "#{line_item.line_item_id}:#{tracking.tracking_category_id}",
      designation_account_id: designation_account_ids["#{tracking.name}:#{tracking.option}"],
      created_at: bank_transaction.date,
      updated_at: bank_transaction.updated_date_utc,
      donor_account_id: donor_account_ids[bank_transaction.contact.id],
      currency: bank_transaction.currency_code,
      amount: line_item.line_amount
    }
  end

  def create_donation(tracking, line_item, bank_transaction)
    attributes = donation_attributes(tracking, line_item, bank_transaction)
    return unless attributes[:designation_account_id] && attributes[:donor_account_id]

    donation = Donation.find_or_initialize_by(remote_id: attributes[:remote_id])
    donation.attributes = attributes
    donation.save!
    donation.remote_id
  end

  def designation_account_ids
    @designation_account_ids ||= DesignationAccount.pluck(:name, :id).to_h
  end

  def donor_account_ids
    @donor_account_ids ||= DonorAccount.pluck(:remote_id, :id).to_h
  end
end
