require 'csv'
CSV.generate do |csv|
  headers = %w[PEOPLE_ID ACCT_NAME]
  csv << headers
  @donor_accounts.each do |donor_account|
    csv << [donor_account.id, donor_account.name]
  end
end
