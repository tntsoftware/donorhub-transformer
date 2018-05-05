class Xero::DesignationAccountsService < Xero::BaseService
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
    client.Account.all
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
