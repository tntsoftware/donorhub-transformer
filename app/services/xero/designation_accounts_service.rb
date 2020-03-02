# frozen_string_literal: true

class Xero::DesignationAccountsService < BaseService
  def load
    account_scope.each do |account|
      attributes = designation_account_attributes(account)
      record = DesignationAccount.find_or_initialize_by(id: attributes[:id])
      record.attributes = attributes
      record.save!
    end
  end

  private

  def account_scope
    all ? client.Account.all : client.Account.all(modified_since: modified_since)
  rescue Xeroizer::OAuth::RateLimitExceeded
    sleep 60
    retry
  end

  def designation_account_attributes(account, attributes = {})
    attributes[:id] = account.id
    attributes[:name] = account.name
    attributes[:remote_id] = account.code
    attributes
  rescue Xeroizer::OAuth::RateLimitExceeded
    sleep 60
    retry
  end
end
