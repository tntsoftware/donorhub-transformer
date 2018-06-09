require "csv"

CSV.generate do |csv|
  headers = %w(
    PEOPLE_ID
    ACCT_NAME
  )

  csv << headers

  @donor_accounts.each do |donor_account|
    csv << [
      donor_account.id,   # PEOPLE_ID
      donor_account.name, # ACCT_NAME
    ]
  end
end
